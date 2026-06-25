extends StaticBody2D
## A building with a procedurally generated, wavy rooftop — a different silhouette every time.
##
## The roofline is sampled from a randomly chosen math function [method f] (sines, sigmoids,
## arcsines, log curves and combinations, selected by [member fx]). For each sample it adds a
## point to the roof polygon, a matching collision segment, and occasional stars. The walls and
## a flat base close off the shape, then the face is tiled with windows. Per the tutorial these
## roofs are forgiving: you won't game-over even if you clip the sides.

var offx:float = 2048  ## Despawn clearance distance (half the generated width).
var offy:int = 96      ## Vertical placement padding so the building sits on screen.
static var Euler:float = 2.7182818284590452353602874713527  ## e, used by the sigmoid/log curves.

var colls:Array = []   ## The per-segment roof colliders.
var Star:Resource = preload("res://GameFiles/Sprites/Currency/Star.tscn")
@onready var bP:Polygon2D = get_node("BuildingPolygon")  ## The filled building shape.
@onready var bO:Line2D = get_node("BuildingOutline")     ## The building's outline stroke.
var polyPnts:Array[Vector2] = []  ## All polygon points (roofline, then walls and base).
var stTemp:Node2D   ## Scratch star instance.
var x:float = 0.0   ## Input to f(x); advances by x_step each sample.
@export var mxSize:int = 128  ## Number of roof samples (roof width in segments).
@export var chx:int = 32      ## Horizontal step between roof samples.
@export var verticality:int = 64  ## Roof height amplitude (how tall the bumps are).
var bHeight:float = 360  ## Height of the solid body below the roofline.
var x_step:float = 0.2   ## Step added to x per sample (the roof "frequency").
var maxPnt:float = -69420 ## Lowest roof point (max Y) seen — used to size the body.
var minPnt:float = 69420  ## Highest roof point (min Y) seen — used to place the building.
var fx:int = 0       ## Which roof function (0-7) f() uses this time.
var w:Array = []     ## Random coefficients for the chosen function.
var deviance:float = 0.0  ## Slow vertical drift added to the roofline.
var d_ch:float       ## Per-sample change in deviance (the drift rate).
var temp             ## Scratch reused in f() and when wiring the wall colliders.

func _ready() -> void:
	randomize()
	mxSize = 32 + randi() % 33
	fx = randi() % 8
	match fx:
		0:
			verticality = 16 + randi() % 249
			x_step = randf_range(0.04, 0.4)
			if randi() % 2:
				x_step *= -1
			x = randf_range(0, 2 * PI)
		1:
			verticality = 16 + randi() % 217
			x_step = randf_range(0.02, 0.08)
			for i in range(3):
				w.push_back(randf_range(-1.5, 1.5))
			if randi() % 2:
				x_step *= -1
			x = randf_range(0, 2 * PI)
		2:
			verticality = 48 + randi() % 301
			x_step = randf_range(0.04, 0.4)
			if randi() % 2:
				x_step *= -1
			x = randf_range(0, 2 * PI)
		3:
			verticality = 32 + randi() % 113
			x_step = randf_range(0.04, 0.2)
			if randi() % 2:
				x_step *= -1
			x = randf_range(-0.9, 0.9)
		4:
			verticality = 48 + randi() % 149
			x_step = randf_range(0.04, 0.33)
			for i in range(2):
				w.push_back(randf_range(0.33, 1))
				if randi() % 2:
					w[w.size()-1] *= -1
			if randi() % 2:
				x_step *= -1
			x = randf_range(0, 2 * PI)
		5:
			verticality = 32 + randi() % 113
			x_step = randf_range(0.04, 0.2)
			for i in range(2):
				w.push_back(randf_range(0.33, 1))
				if randi() % 2:
					w[w.size()-1] *= -1
			if randi() % 2:
				x_step *= -1
			x = randf_range(-0.9, 0.9)
		6:
			verticality = 48 + randi() % 301
			x_step = randf_range(0.08, 0.28)
			if randi() % 2:
				x_step *= -1
			w.push_back(randf_range(1.33, 1.9))
			x = randf_range(0, 2 * PI)
		7:
			verticality = 48 + randi() % 301
			x_step = randf_range(0.08, 0.2)
			w.push_back(randf_range(1.33, 1.9))
			for i in range(2):
				w.push_back(randf_range(0.33, 1))
				if randi() % 2:
					w[w.size()-1] *= -1
			if randi() % 2:
				x_step *= -1
			x = randf_range(0, 2 * PI)

	# Centre the generated shape on this node's origin.
	offx = (mxSize * chx) / 2.0
	bP.position.x = -offx
	bO.position.x = -offx
	position.y = 650

	# Walk the roofline left-to-right, sampling f(x) for each point and building a
	# collision segment between consecutive points (with stars on every other point).
	polyPnts.push_back(Vector2(0, verticality*f(x) + deviance))
	maxPnt = max(maxPnt, polyPnts.back().y)
	minPnt = min(minPnt, polyPnts.back().y)
	d_ch = 0
	if randi() % 2:
		d_ch = randf_range(-10, 10)
	for i in range(mxSize):
		if abs(x) > 1 + abs(x_step) and (fx == 3 or fx == 5):
			x_step *= -1
		x += x_step
		deviance += d_ch
		polyPnts.push_back(Vector2(polyPnts.back().x + chx, verticality*f(x) + deviance))
		maxPnt = max(maxPnt, polyPnts.back().y)
		minPnt = min(minPnt, polyPnts.back().y)
		colls.push_back(CollisionShape2D.new())
		colls.back().shape = SegmentShape2D.new()
		colls.back().shape.a = polyPnts[polyPnts.size()-2] - Vector2(offx, 0)
		colls.back().shape.b = polyPnts.back() - Vector2(offx, 0)
		add_child(colls.back())
		
		if i % 2 == 0:
			stTemp = Star.instantiate()
			stTemp.position = polyPnts.back() + Vector2(0, -36)
			bP.add_child(stTemp)
	
	# Place the building at a random valid height now that the roof's extent is known.
	if minPnt < 0:
		offy -= minPnt
	position.y = offy + randi() % int(max(1, 968 - (maxPnt - minPnt)))
	bHeight = max(100, 1100 - maxPnt - position.y)

	# Close the polygon with the right wall, base and left wall back to the start.
	polyPnts.push_back(Vector2(polyPnts.back().x, maxPnt + bHeight))
	polyPnts.push_back(Vector2(0, polyPnts.back().y))
	polyPnts.push_back(polyPnts[0])
	
	temp = get_children()
	temp[1].position.x = -offx
	temp[1].shape = SegmentShape2D.new()
	temp[1].shape.a = polyPnts[polyPnts.size()-2]
	temp[1].shape.b = polyPnts[polyPnts.size()-1] + Vector2(0, 16)
	temp[2].position.x = -offx
	temp[2].shape = SegmentShape2D.new()
	temp[2].shape.a = polyPnts[polyPnts.size()-4] + Vector2(0, 16)
	temp[2].shape.b = polyPnts[polyPnts.size()-3]
	
	bP.set_polygon(polyPnts)
	bO.set_points(polyPnts)
	bP.decorationTime(maxPnt, polyPnts[polyPnts.size()-2].y, 0, offx * 2)

## The roofline shape function: returns a height for input [param x] using whichever curve
## [member fx] selected (sine, sigmoid, arcsine, log, or polynomial combinations of them). The
## random [member w] coefficients give each building its own character.
func f(x:float) -> float:
	match fx:
		0:
			return sin(x)
		1:
			return sin(w[0]*x*x + w[1]*x + w[2])
		2:
			return 1 / (1 + Euler**-(2*PI*sin(x)))
		3:
			return asin(x)
		4:
			temp = sin(x)
			return w[0]*temp*temp + w[1]*temp
		5:
			temp = asin(x)
			return w[0]*temp*temp + w[1]*temp
		6:
			return log(sin(x) + w[0])
		7:
			temp = log(sin(x) + w[0])
			return w[1]*temp*temp + w[2]*temp
	
	return x

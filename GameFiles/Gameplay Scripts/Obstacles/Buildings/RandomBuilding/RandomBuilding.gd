extends StaticBody2D

var offx:float = 2048
var offy:int = 96
static var Euler:float = 2.7182818284590452353602874713527

var colls:Array = []
var Star:Resource = preload("res://GameFiles/Sprites/Currency/Star.tscn")
@onready var bP:Polygon2D = get_node("BuildingPolygon")
@onready var bO:Line2D = get_node("BuildingOutline")
var polyPnts:Array[Vector2] = []
var stTemp:Node2D
var x:float = 0.0
@export var mxSize:int = 128
@export var chx:int = 32
@export var verticality:int = 64
var bHeight:float = 360
var x_step:float = 0.2
var maxPnt:float = -69420
var minPnt:float = 69420
var fx:int = 0
var w:Array = []
var deviance:float = 0.0
var d_ch:float
var temp

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

	offx = (mxSize * chx) / 2.0
	bP.position.x = -offx
	bO.position.x = -offx
	position.y = 650
	
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
	
	if minPnt < 0:
		offy -= minPnt
	position.y = offy + randi() % int(max(1, 968 - (maxPnt - minPnt)))
	bHeight = max(100, 1100 - maxPnt - position.y)
	
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

extends StaticBody2D

var Rockstar:Resource = preload("res://GameFiles/Sprites/Powerups/RockstarGuitar.tscn")
var Jetpack:Resource = preload("res://GameFiles/Sprites/Powerups/Jetpack.tscn")
var Dopel:Resource = preload("res://GameFiles/Sprites/Powerups/Doppelgänger.tscn")
var Umbrella:Resource = preload("res://GameFiles/Sprites/Powerups/Umbrella.tscn")
var Lowrider:Resource = preload("res://GameFiles/Sprites/Powerups/Lowrider.tscn")

var offx:float = 2420
var offy:int = 96
static var Euler:float = 2.7182818284590452353602874713527

var colls:Array = []
var Star:Resource = preload("res://GameFiles/Sprites/Currency/Star.tscn")
@onready var bP:Polygon2D = get_node("BuildingPolygon")
@onready var bO:Line2D = get_node("BuildingOutline")
var polyPnts:Array[Vector2] = []
var stTemp:Node2D
var x:float = 0
@export var mxSize:int = 128
@export var chx:int = 32
@export var verticality:int = 64
var bHeight:float = 360
var x_step:float = 0.2
var maxPnt:float = -69420
var minPnt:float = 69420
var fx:int = 0
var w:Array = []
var deviance:float = 0
var d_ch:float
var temp

func _ready() -> void:
	randomize()
	mxSize = 32 + randi() % 32
	mxSize += int(not(bool(mxSize%2)))
	fx = randi() % 4
	match fx:
		0:
			verticality = 16 + randi() % 181
			x_step = randf_range(0.04, 0.33)
			if randi() % 2:
				x_step *= -1
			x = PI / 2
		1:
			verticality = 32 + randi() % 225
			x_step = randf_range(0.04, 0.4)
			if randi() % 2:
				x_step *= -1
			x = PI / 2
		2:
			verticality = 16 + randi() % 65
			x_step = randf_range(0.1, 0.33)
			if randi() % 2:
				x_step *= -1
			x = PI / 2
		3:
			verticality = 32 + randi() % 225
			x_step = randf_range(0.08, 0.25)
			if randi() % 2:
				x_step *= -1
			w.push_back(randf_range(1.33, 1.9))
			x = PI / 2
	
	if randi() % 2:
		x *= -1
	x -= x_step * int(mxSize / 2)
		
	offx = (mxSize * chx) / 2.0
	bP.position.x = -offx
	bO.position.x = -offx
	get_node("CollisionShape2D").position.x = -offx
	get_node("CollisionShape2D2").position.x = -offx
	position.y = 650
	
	polyPnts.push_back(Vector2(0, verticality*f(x) + deviance))
	maxPnt = max(maxPnt, polyPnts.back().y)
	minPnt = min(minPnt, polyPnts.back().y)
	d_ch = 0
	if randi() % 2:
		d_ch = randf_range(-4, 4)
	for i in range(mxSize):
		x += x_step
		deviance += d_ch
		polyPnts.push_back(Vector2(polyPnts.back().x + chx, verticality*f(x) + deviance))
		maxPnt = max(maxPnt, polyPnts.back().y)
		minPnt = min(minPnt, polyPnts.back().y)
		giveBirth()
		
		if i % 2 == 0 and abs(int(mxSize/2 - 1) - i) > 2:
			stTemp = Star.instantiate()
			stTemp.position = polyPnts.back() + Vector2(0, -36)
			bP.add_child(stTemp)
			
		if i == int(mxSize/2 - 1):
			match randi() % 10:
				0:
					if not get_tree().get_nodes_in_group("PowerupPopUps")[1].visible:
						stTemp = Rockstar.instantiate()
						stTemp.position = polyPnts.back() + Vector2(0, -36)
						bP.add_child(stTemp)
				1:
					if not get_tree().get_nodes_in_group("PowerupPopUps")[2].visible:			
						stTemp = Jetpack.instantiate()
						stTemp.position = polyPnts.back() + Vector2(0, -36)
						bP.add_child(stTemp)
				2:
					if not get_tree().get_nodes_in_group("PowerupPopUps")[3].visible:
						stTemp = Dopel.instantiate()
						stTemp.position = polyPnts.back() + Vector2(0, -36)
						bP.add_child(stTemp)
				3:
					if not get_tree().get_nodes_in_group("PowerupPopUps")[4].visible:
						stTemp = Umbrella.instantiate()
						stTemp.position = polyPnts.back() + Vector2(0, -36)
						bP.add_child(stTemp)
				4:
					if not get_tree().get_nodes_in_group("PowerupPopUps")[5].visible:
						stTemp = Lowrider.instantiate()
						stTemp.position = polyPnts.back() + Vector2(0, -36)
						bP.add_child(stTemp)
	
	x = 0
	var cnt:int = 0
	x_step = randf_range(0.18, 0.33)
	verticality = 128 + randi() % 129
	w = [polyPnts[polyPnts.size() - 1].x, 0]
	while x < PI:
		cnt += 1
		x += x_step
		deviance += d_ch
		polyPnts.push_back(Vector2(w[0] + verticality*log(sin(x) + 1.5), polyPnts.back().y - chx))
		polyPnts.push_front(Vector2(w[0] - polyPnts.back().x, polyPnts.front().y - chx))
		giveBirth()
		giveAnotherBirth()
		
		if cnt % 2 == 0:
			stTemp = Star.instantiate()
			stTemp.position = polyPnts.back() + Vector2(-36, 0)
			bP.add_child(stTemp)
			stTemp = Star.instantiate()
			stTemp.position = polyPnts.front() + Vector2(36, 0)
			bP.add_child(stTemp)
	cnt = 32 + randi() % 201
	polyPnts.push_back(Vector2(polyPnts.back().x - cnt, polyPnts.back().y))
	polyPnts.push_front(Vector2(polyPnts.front().x + cnt, polyPnts.front().y))
	giveBirth()
	giveAnotherBirth()
	polyPnts.push_back(Vector2(polyPnts.back().x, polyPnts.back().y - 2 * chx))
	polyPnts.push_front(Vector2(polyPnts.front().x, polyPnts.front().y - 2 * chx))
	minPnt = min(minPnt, polyPnts.back().y)
	minPnt = min(minPnt, polyPnts.front().y)
	giveBirth()
	giveAnotherBirth()
	
	cnt = int((1064 - offy - (maxPnt - minPnt)))
	if minPnt < 0:
		offy -= minPnt
	position.y = offy + randi() % max(1, cnt)
	bHeight = max(100, 1100 - maxPnt - position.y)
	
	polyPnts.push_back(Vector2(w[0] + 1.5 * verticality, polyPnts.back().y))
	polyPnts.push_front(Vector2(-1.5 * verticality, polyPnts.front().y))
	giveBirth()
	giveAnotherBirth()
	offx = (polyPnts.back().x - polyPnts.front().x) / 2 + 64
	polyPnts.push_back(Vector2(polyPnts.back().x, maxPnt + bHeight))
	polyPnts.push_back(Vector2(polyPnts.front().x, polyPnts.back().y))
	polyPnts.push_back(polyPnts[0])
	
	temp = get_children()
	temp[1].shape = SegmentShape2D.new()
	temp[1].shape.a = polyPnts[polyPnts.size()-2]
	temp[1].shape.b = polyPnts[polyPnts.size()-1] + Vector2(0, 16)
	temp[2].shape = SegmentShape2D.new()
	temp[2].shape.a = polyPnts[polyPnts.size()-4] + Vector2(0, 16)
	temp[2].shape.b = polyPnts[polyPnts.size()-3]
	
	bP.set_polygon(polyPnts)
	bO.set_points(polyPnts)
	bP.decorationTime(maxPnt, polyPnts[polyPnts.size()-2].y, polyPnts[0].x, polyPnts[polyPnts.size()-3].x)

func f(x:float) -> float:
	match fx:
		0:
			return sin(x)
		1:
			return 1 / (1 + Euler**-(2*PI*sin(x)))
		2:
			return asin((1 + x_step) * sin(x))
		3:
			return log(sin(x) + w[0])
	
	return x

func giveBirth() -> void:
	colls.push_back(CollisionShape2D.new())
	colls.back().shape = SegmentShape2D.new()
	colls.back().shape.a = polyPnts[polyPnts.size()-2] - Vector2(offx, 0)
	colls.back().shape.b = polyPnts.back() - Vector2(offx, 0)
	add_child(colls.back())

func giveAnotherBirth() -> void:
	colls.push_back(CollisionShape2D.new())
	colls.back().shape = SegmentShape2D.new()
	colls.back().shape.a = polyPnts[1] - Vector2(offx, 0)
	colls.back().shape.b = polyPnts[0] - Vector2(offx, 0)
	add_child(colls.back())

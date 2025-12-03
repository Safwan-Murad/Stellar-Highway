extends Node2D

static var offx:int = 1280

var rngMan:int
var obSp:Sprite2D

var StW:Resource = preload("res://GameFiles/Sprites/Obstacles/Hotel/Obstacles/StupidWall.tscn")
var SmW:Resource = preload("res://GameFiles/Sprites/Obstacles/Hotel/Obstacles/SmoothWall.tscn")

func _ready() -> void:
	position.y = 540
	randomize()
	rngMan = randi() % 3
	for i in range(3):
		get_child(i).position.y = (rngMan - 1) * 360
		rngMan = (rngMan + 1) % 3
	if randi() % 100 == 0:
		get_child(0).get_child(1).play("S6")
	else:
		get_child(0).get_child(1).play("S5")
	get_node("../indicatorManager").indicateHotel()
	rngMan = randi() % 2
	for i in range(2):
		match rngMan:
			0:
				stupidWall(i+1)
			1:
				smoothWall(i+1)

func stupidWall(hall:int) -> void:
	get_child(0).get_child(0).play("StupidWall")
	for i in range(3):
		obSp = StW.instantiate()
		obSp.position.x = 640 * (i - 1)
		if randi() % 2:
			obSp.position.y = 55 + randi() % 53
		else:
			obSp.flip_v = true
			obSp.position.y = -69 - randi() % 53
			
		get_child(hall).add_child(obSp)

func smoothWall(hall:int) -> void:
	get_child(0).get_child(0).play("SmoothWall")
	for i in range(3):
		obSp = SmW.instantiate()
		obSp.position.x = 640 * (i - 1)
		obSp.scale.x = 1 - (randi() % 2) * 2
		if randi() % 2:
			obSp.position.y = 45 + randi() % 61
		else:
			obSp.scale.y = -1
			obSp.position.y = -59 - randi() % 61
			
		get_child(hall).add_child(obSp)

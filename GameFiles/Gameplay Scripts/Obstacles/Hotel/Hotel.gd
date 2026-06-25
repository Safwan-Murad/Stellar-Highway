extends Node2D
## The hotel: roll through its horizontal halls without touching the deadly red walls.
##
## It has three stacked halls; this shuffles which one the player enters and decorates two of
## them with hazard walls — either jagged "stupid" walls ([method stupidWall]) or curved
## "smooth" walls ([method smoothWall]), placed jutting from the floor or ceiling. Triggers the
## hotel danger indicator on spawn. [member offx] is the despawn clearance for the generator.

static var offx:int = 1280  ## Despawn clearance distance used by ObstacleGenerator.

var rngMan:int       ## Reusable random selector (which hall, which wall style, etc.).
var obSp:Sprite2D    ## Scratch: each hazard wall being placed.

var StW:Resource = preload("res://GameFiles/Sprites/Obstacles/Hotel/Obstacles/StupidWall.tscn")  ## Jagged hazard wall.
var SmW:Resource = preload("res://GameFiles/Sprites/Obstacles/Hotel/Obstacles/SmoothWall.tscn")  ## Curved hazard wall.

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

## Fill [param hall] with three jagged "stupid" hazard walls, each randomly from floor or ceiling.
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

## Fill [param hall] with three curved "smooth" hazard walls, randomly flipped and from floor or ceiling.
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

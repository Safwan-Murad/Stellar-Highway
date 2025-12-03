extends Node2D

var offx:int = 500

@onready var HeavyPendulum:Resource = preload("res://GameFiles/Sprites/Obstacles/Buildings/UnderConstruction/HeavyPendulum.tscn")
@onready var IncompleteBuilding:Resource = preload("res://GameFiles/Sprites/Obstacles/Buildings/UnderConstruction/IncompleteBuilding.tscn")
var building:Array = [null, null]
var morePlz:int = 1

func _ready() -> void:
	randomize()
	position.y = 540
	morePlz = 1 + randi() % 4
	offx += (morePlz - 1) * 1024
	for i in range(morePlz):
		building[0] = HeavyPendulum.instantiate()
		building[0].position.x = i * 1024
		building[0].position.y = -580 -(randi() % 541)
		building[0].rotation = randf_range(PI/12, PI/6)
		if randi() % 2:
			building[0].rotation *= -1
		building[0].ThetaMax = randf_range(0.04, 0.1)
		add_child(building[0])
		building[1] = IncompleteBuilding.instantiate()
		building[1].position.x = building[0].position.x
		building[1].position.y = randf_range(500, building[0].position.y + 812)
		add_child(building[1])

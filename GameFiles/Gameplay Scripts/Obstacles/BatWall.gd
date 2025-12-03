extends Node2D

var offx:int = 1920
var wall_dist:int = 1920

var walls:int
var dontman:int
var velocity:float = 1.0
var difficulty:float = 1.0
var WallBat:Resource = preload("res://GameFiles/Sprites/Obstacles/WalloBats/WallBat.tscn")
var Star:Resource = preload("res://GameFiles/Sprites/Currency/Star.tscn")
var wb:Node2D

func _ready() -> void:
	randomize()
	walls = randi()%4 + 1
	offx = (walls - 1) * wall_dist + 1024
	for i in range(walls):
		dontman = randi()%22 + 1
		for j in range(25):
			if abs(j - dontman) <= 2:
				wb = Star.instantiate()
			else:
				wb = WallBat.instantiate()
			wb.position = Vector2(i*wall_dist, j*45)
			add_child(wb)

func _process(_delta:float) -> void:
	position.x -= velocity * difficulty

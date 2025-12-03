extends Node2D

var offx:int = 1229
var RNG:float

func _ready() -> void:
	randomize()
	RNG = randf_range(1, 1.1)
	scale = Vector2(RNG, RNG)
	offx = 1024 * RNG

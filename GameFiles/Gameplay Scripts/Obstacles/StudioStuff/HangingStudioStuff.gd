extends Node2D

static var offx:int = 1024

func _ready() -> void:
	position.y = 540
	randomize()
	if randi() % 2:
		get_node("Bars").rotation = randf_range(PI - 0.28, PI - 0.028)
	else:
		get_node("Bars").rotation = -randf_range(PI - 0.28, PI - 0.028)
	get_node("../indicatorManager").indicateHSS()

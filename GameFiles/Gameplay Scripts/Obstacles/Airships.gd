extends Node2D

static var offx:int = 1920

func _ready() -> void:
	position.y = 0
	randomize()
	get_child(randi() % 3).queue_free()
	if randi() % 2:
		get_child(randi() % 2).queue_free()
	await get_tree().create_timer(0.1).timeout
	get_node("../indicatorManager").indicateAirships()
	
	for child in get_children():
		child.velocity = randf_range(3.0, 7.0)

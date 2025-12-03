extends Node2D

static var offx:int = 348

func _ready() -> void:
	randomize()
	if get_node("../../").name != "MainMenu":
		position.y = 475 + randi() % 76
	var temp:int = randi() % 2
	if temp:
		get_node("Blades0").queue_free()
	else:
		get_node("Blades1").queue_free()

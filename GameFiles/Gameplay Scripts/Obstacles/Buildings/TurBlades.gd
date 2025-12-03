extends StaticBody2D

@onready var anim:AnimationPlayer = get_node("Spinner")

func _ready() -> void:
	randomize()
	anim.speed_scale = randf_range(1, 3) * (-1 + 2 * (randi() % 2))

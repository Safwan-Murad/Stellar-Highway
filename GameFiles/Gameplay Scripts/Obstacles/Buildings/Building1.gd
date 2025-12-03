extends StaticBody2D

static var offx:int = 158

func _ready() -> void:
	randomize()
	position.y = 711 + randi() % 250
	if get_node_or_null("SpeedBooster"):
		if randi() % 2:
			get_node("SpeedBooster").queue_free()

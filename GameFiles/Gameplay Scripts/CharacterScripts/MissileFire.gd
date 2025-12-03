extends AnimatedSprite2D

func _ready() -> void:
	if get_node("../").visible:
		randomize()
		if randi()%2 == 1:
			play("fire_R")
		else:
			play("fire_B")

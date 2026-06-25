extends AnimatedSprite2D
## The animated jet flame on a lock-on missile. Picks one of two flame colours (red/blue)
## at random when the missile spawns visible.

func _ready() -> void:
	if get_node("../").visible:
		randomize()
		if randi()%2 == 1:
			play("fire_R")
		else:
			play("fire_B")

extends AnimatedSprite2D
## A single bat tile within a BatWall — just plays its flap animation. (The wall itself
## handles movement and collision.)

func _ready() -> void:
	play("Fly")

extends Sprite2D

var velocity:float = 0.0

func _process(_delta:float) -> void:
	position.x -= velocity

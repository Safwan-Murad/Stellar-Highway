extends Sprite2D

var grow = true
@onready var smSize = scale

func _ready():
	anim()
	
func anim():
	var tween = get_tree().create_tween()
	if grow:
		tween.tween_property(self, "scale", Vector2(1, 1), 2).set_ease(Tween.EASE_IN_OUT).set_delay(0.2)
		grow = !grow
	else:
		tween.tween_property(self, "scale", smSize, 2).set_ease(Tween.EASE_IN_OUT).set_delay(0.2)
		grow = !grow

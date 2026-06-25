extends Sprite2D
## A pulsing "breathing" glow (e.g. the star glow on the HUD).
##
## Each [method anim] call tweens the scale one way and flips [member grow], so successive
## calls alternate between growing to full size and shrinking back to the base size.

var grow = true            ## Direction of the next tween (grow vs shrink).
@onready var smSize = scale  ## The small/base scale to shrink back to.

func _ready():
	anim()

## Tween the scale one leg of the pulse (grow or shrink) and flip the direction for next time.
func anim():
	var tween = get_tree().create_tween()
	if grow:
		tween.tween_property(self, "scale", Vector2(1, 1), 2).set_ease(Tween.EASE_IN_OUT).set_delay(0.2)
		grow = !grow
	else:
		tween.tween_property(self, "scale", smSize, 2).set_ease(Tween.EASE_IN_OUT).set_delay(0.2)
		grow = !grow

extends Sprite2D
## Shared helper: drift a sprite leftward at a fixed per-frame speed.
##
## Reused by simple scrolling props (e.g. the individual airships in an Airships group),
## which set [member velocity] to give each one its own drift speed.

var velocity:float = 0.0  ## Pixels moved left each frame.

func _process(_delta:float) -> void:
	position.x -= velocity

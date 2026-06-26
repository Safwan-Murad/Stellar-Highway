extends Camera2D
## Trauma-based screen shake on the player camera. Trigger it with [code]Refs.shake(amount)[/code].
##
## It shakes the camera's [member offset]: [member offset].y is set relative to its resting value,
## and [member offset].x is added on top of the look-ahead that changeSize.gd writes every frame
## (skipped while paused, since changeSize stops then and the value would otherwise drift). Runs even
## while the tree is paused so the game-over shake still plays. Rotation isn't used because the
## camera has ignore_rotation on (to stay upright while the player rolls), and position is smoothed.

const MAX_SHAKE := 24.0   ## Max camera offset (px) at full trauma.
const DECAY := 1.5        ## Trauma lost per second.

var trauma: float = 0.0   ## Current shake intensity, 0..1.
var base_y: float         ## The camera's resting vertical offset, so the shake is relative.

func _ready() -> void:
	add_to_group("CameraShake")
	process_mode = Node.PROCESS_MODE_ALWAYS  # keep shaking during the game-over pause
	base_y = offset.y

func _process(delta: float) -> void:
	if trauma <= 0.0:
		offset.y = base_y
		return
	trauma = maxf(0.0, trauma - DECAY * delta)
	var amount: float = MAX_SHAKE * trauma * trauma  # quadratic falloff feels punchier
	offset.y = base_y + amount * randf_range(-1.0, 1.0)
	# changeSize.gd resets offset.x every unpaused frame, so add on top; skip while paused (it stops).
	if not get_tree().paused:
		offset.x += amount * randf_range(-1.0, 1.0)

## Adds screen-shake trauma ([param amount] in 0..1; stacks, capped at 1).
func add_trauma(amount: float) -> void:
	trauma = minf(1.0, trauma + amount)

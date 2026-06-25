extends TouchScreenButton
## The on-screen bounce button (visible only while the Lowrider powerup is held).
##
## It's in the "MoreBounce" group so the Lowrider can show/hide it. Pressing it synthesises
## a press-and-release of the "ui_accept" action, which the OnGround state reads as a jump.

func _ready() -> void:
	add_to_group("MoreBounce")

## Synthesise a brief "ui_accept" press so the physics jumps, then release it.
func _on_pressed() -> void:
	var accept_ev = InputEventAction.new()
	accept_ev.action = "ui_accept"
	accept_ev.pressed = true
	Input.parse_input_event(accept_ev)
	get_node("AnimationPlayer").play("onClick")
	await get_tree().create_timer(0.2).timeout
	accept_ev.pressed = false
	Input.parse_input_event(accept_ev)

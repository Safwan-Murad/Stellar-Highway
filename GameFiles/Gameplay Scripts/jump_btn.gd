extends TouchScreenButton

func _ready() -> void:
	add_to_group("MoreBounce")

func _on_pressed() -> void:
	var accept_ev = InputEventAction.new()
	accept_ev.action = "ui_accept"
	accept_ev.pressed = true
	Input.parse_input_event(accept_ev)
	get_node("AnimationPlayer").play("onClick")
	await get_tree().create_timer(0.2).timeout
	accept_ev.pressed = false
	Input.parse_input_event(accept_ev)

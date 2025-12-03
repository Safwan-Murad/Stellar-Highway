extends AnimatedSprite2D

func _on_sign_frame_changed() -> void:
	frame = get_node("../Sign").frame

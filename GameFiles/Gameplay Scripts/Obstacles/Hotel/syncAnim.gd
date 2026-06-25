extends AnimatedSprite2D
## Keeps this animated sprite's frame in lockstep with a sibling "Sign" sprite, so the hotel's
## neon sign and its glow/reflection animate together.

func _on_sign_frame_changed() -> void:
	frame = get_node("../Sign").frame

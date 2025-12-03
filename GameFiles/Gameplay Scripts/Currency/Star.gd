extends Node2D

var sus:bool = false

func _on_kill_me_body_entered(body:Node) -> void:
		if (body.name == "Player" or body.name == "PlayerSUS") and not sus:
			body.playStarSound()
			sus = true
			get_tree().get_first_node_in_group("StarCnt").stars += 1
			if body.get_node_or_null("Lowrider"):
				get_tree().get_first_node_in_group("Score").extra += 100
			get_node("./Fade").play("onCollect")

func _on_fade_animation_finished(_anim_name:String) -> void:
	self.queue_free()

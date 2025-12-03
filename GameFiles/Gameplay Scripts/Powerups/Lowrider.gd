extends Node2D

var sus:bool = false

func _on_hitbox_body_entered(body:Node) -> void:
	if body.name == "Player" and not sus:
		sus = true
		body.can_jump = true
		get_tree().get_first_node_in_group("MoreBounce").visible = true
		get_tree().get_nodes_in_group("PowerupPopUps")[0].text = "LOWRIDER"
		get_tree().get_nodes_in_group("PowerupPopUps")[0].get_node("AnimationPlayer").play("PopUp")
		get_tree().get_nodes_in_group("PowerupPopUps")[5].visible = true
		get_node("LowriderJUMP").play()
		get_child(0).queue_free()
		reparent(body)
		position = Vector2(8, 8)

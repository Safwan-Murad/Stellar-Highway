extends Area2D

func _on_body_entered(body:Node) -> void:
	if body.name == "Player":
		body.tartar_sauce()
	elif body.name == "PlayerSUS":
		if get_tree().get_nodes_in_group("PowerupPopUps"):
			get_tree().get_nodes_in_group("PowerupPopUps")[3].visible = false
			get_tree().get_first_node_in_group("Player").playDoppelDead()
		body.queue_free()

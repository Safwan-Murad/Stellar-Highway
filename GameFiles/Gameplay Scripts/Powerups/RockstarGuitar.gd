extends Node2D

var sus:bool = false

func _on_kill_me_body_entered(body:Node) -> void:
	if body.name == "Player" and not sus:
		sus = true
		get_tree().get_first_node_in_group("playerInput").powerup = true
		get_tree().get_nodes_in_group("PowerupPopUps")[0].text = "ROCKSTAR"
		get_tree().get_nodes_in_group("PowerupPopUps")[0].get_node("AnimationPlayer").play("PopUp")
		get_node("RockstarSound").play()
		get_tree().get_nodes_in_group("PowerupPopUps")[1].visible = true
		get_child(0).queue_free()
		reparent(body)
		position = Vector2(12, -6)
		await get_tree().create_timer(10).timeout
		get_tree().get_first_node_in_group("playerInput").powerup = false
		get_tree().get_nodes_in_group("PowerupPopUps")[0].text = ""
		get_tree().get_nodes_in_group("PowerupPopUps")[1].visible = false
		self.queue_free()

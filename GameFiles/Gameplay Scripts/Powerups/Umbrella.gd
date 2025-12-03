extends Node2D

var sus:bool = false

func _on_hitbox_body_entered(body:Node) -> void:
	if body.name == "Player" and not sus:
		sus = true
		body.grv_scaler = 0.33
		get_tree().get_nodes_in_group("PowerupPopUps")[0].text = "UMBRELLA"
		get_tree().get_nodes_in_group("PowerupPopUps")[0].get_node("AnimationPlayer").play("PopUp")
		get_node("UmbrellaSound").play()
		get_tree().get_nodes_in_group("PowerupPopUps")[4].visible = true
		get_child(0).queue_free()
		reparent(body)
		position = Vector2(4, -24)

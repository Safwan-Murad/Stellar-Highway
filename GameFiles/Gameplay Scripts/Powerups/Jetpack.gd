extends Node2D

var sus:bool = false

func _on_hitbox_body_entered(body:Node) -> void:
	if body.name == "Player" and not sus:
		sus = true
		body.spdOffset = 400
		body.TOPROLL += 3 * body.spdOffset
		get_tree().get_nodes_in_group("PowerupPopUps")[0].text = "JETPACK"
		get_tree().get_nodes_in_group("PowerupPopUps")[0].get_node("AnimationPlayer").play("PopUp")
		get_tree().get_nodes_in_group("PowerupPopUps")[2].visible = true
		get_node("FireLine").active = true
		get_node("FireLine2").active = true
		get_child(0).queue_free()
		reparent(body)
		position = Vector2(12, -6)
		get_node("JetStart").play()
		get_node("JetSound").play()

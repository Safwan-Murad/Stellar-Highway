extends Node2D
## Umbrella powerup: a slow, floaty fall.
##
## On pickup it cuts the player's gravity ([code]grv_scaler[/code] = 0.33), shows the HUD icon,
## and rides along. Also a defensive powerup — a hit consumes it for invincibility instead of
## ending the run.

var sus:bool = false  ## Guard so the pickup only triggers once.

## On the player touching the powerup, soften gravity and attach to the player.
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

extends Node2D
## Lowrider powerup: lets the player jump/bounce.
##
## On pickup it enables jumping ([code]can_jump[/code]), reveals the on-screen bounce button
## (the "MoreBounce" group), shows the HUD icon, and rides along. Also a defensive powerup —
## a hit consumes it for invincibility instead of ending the run.

var sus:bool = false  ## Guard so the pickup only triggers once.

## On the player touching the powerup, enable jumping and attach to the player.
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

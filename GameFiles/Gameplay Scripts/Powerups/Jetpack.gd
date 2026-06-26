extends Node2D
## Jetpack powerup: a big speed boost plus thrust and flames.
##
## On pickup it raises the player's speed ([code]spdOffset[/code]) and rolling cap, shows the
## HUD icon, lights its fire trails, and re-parents to the player so it rides along. The
## OnAir state then adds forward thrust while airborne. It's a defensive powerup too: getting
## hit while holding it is absorbed by [code]tartar_sauce[/code] instead of ending the run.

var sus:bool = false  ## Guard so the pickup only triggers once.

## On the player touching the powerup, apply the jetpack boost and attach to the player.
func _on_hitbox_body_entered(body:Node) -> void:
	if body.name == "Player" and not sus:
		sus = true
		Settings.vibrate(30)
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

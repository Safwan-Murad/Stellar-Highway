extends Node2D
## Rockstar Guitar powerup: for 10 seconds, the lines you draw sprout stars.
##
## On pickup it flips playerInput's [code]powerup[/code] flag (so drawn segments scatter
## stars), shows the HUD icon, and rides along. After 10 seconds it clears the flag and
## frees itself.

var sus:bool = false  ## Guard so the pickup only triggers once.

## On the player touching the powerup, enable star-drawing for 10 seconds.
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

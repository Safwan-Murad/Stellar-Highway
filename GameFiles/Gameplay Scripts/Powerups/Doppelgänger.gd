extends Node2D
## Doppelgänger powerup: spawns a clone that mirrors you and soaks one hit.
##
## On pickup it instantiates a [code]PlayerSUS[/code] body next to the player, copying its
## speed and velocity. The clone trails the real player (see player_physics.gd) and adds its
## distance to the score as bonus; when it's destroyed the real player keeps going.
## ("sus"/"imposter" are Among Us jokes — it's just the player's twin.)

var sus:bool = false  ## Guard so the pickup only triggers once.
var imposter:Resource = preload("res://GameFiles/Sprites/PlayerSUS.tscn")  ## The clone scene.
var da_sus:CharacterBody2D  ## The spawned clone.

## On the player touching the powerup, spawn and launch the mirrored clone.
func _on_hitbox_body_entered(body:Node) -> void:
	if body.name == "Player" and not sus:
		sus = true
		Settings.vibrate(30)
		get_tree().get_nodes_in_group("PowerupPopUps")[0].text = "DOPPELGÄNGER"
		get_tree().get_nodes_in_group("PowerupPopUps")[0].get_node("AnimationPlayer").play("PopUp")
		get_tree().get_nodes_in_group("PowerupPopUps")[3].visible = true
		da_sus = imposter.instantiate()
		da_sus.position = body.position + Vector2(64, 0)
		da_sus.minSpeed = body.minSpeed
		da_sus.spdOffset = body.spdOffset
		da_sus.TOPROLL = body.TOPROLL
		da_sus.velocity = body.velocity
		get_tree().get_first_node_in_group("Playfield").add_child(da_sus)
		get_node("DoppelSound").reparent(da_sus)
		da_sus.get_node("DoppelSound").play()
		queue_free() 

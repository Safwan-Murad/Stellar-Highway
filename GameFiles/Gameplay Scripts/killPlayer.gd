extends Area2D
## A lethal hitbox (e.g. a building's side wall). Touching it ends the run.
##
## Hits on the real player route through [code]tartar_sauce()[/code] (which may be
## absorbed by a defensive powerup); hits on the Doppelgänger clone just kill the clone.

func _on_body_entered(body:Node) -> void:
	if body.name == "Player":
		body.tartar_sauce()
	elif body.name == "PlayerSUS":
		if get_tree().get_nodes_in_group("PowerupPopUps"):
			get_tree().get_nodes_in_group("PowerupPopUps")[3].visible = false
			get_tree().get_first_node_in_group("Player").playDoppelDead()
		body.queue_free()

extends Node2D

var sus:bool = false
var imposter:Resource = preload("res://GameFiles/Sprites/PlayerSUS.tscn")
var da_sus:CharacterBody2D

func _on_hitbox_body_entered(body:Node) -> void:
	if body.name == "Player" and not sus:
		sus = true
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

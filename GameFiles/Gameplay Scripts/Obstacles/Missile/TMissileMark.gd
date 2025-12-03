extends Node2D

var cooldown:float = 0.2
@onready var sound_player:AudioStreamPlayer2D = get_node("MissileBeep")
@onready var player:CharacterBody2D = get_node("../Player")
var missilePos:Vector2
var missiles:Array

func _process(_delta:float) -> void:
	missiles = get_tree().get_nodes_in_group("TMissiles")
	if missiles.size() > 0:
		missilePos = missiles[0].position
	else:
		self.queue_free()
	for missile in missiles:
		if missile.position.distance_to(player.position) < missilePos.distance_to(player.position):
			missilePos = missile.position
	cooldown = min(0.0002 * missilePos.distance_to(player.position), 0.2)
	sound_player.position = missilePos

func _on_missile_beep_finished() -> void:
		sound_player.play()

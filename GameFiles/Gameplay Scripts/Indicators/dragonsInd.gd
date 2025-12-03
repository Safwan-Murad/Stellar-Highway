extends Node2D

@onready var sound_player:AudioStreamPlayer2D = get_node("DangerBeep")
@onready var parent:Node2D = get_node("../")
@onready var player:CharacterBody2D = get_node("../Player")
var dragon:Node

func indicateStart(place:int, dr:Node) -> void:
	if place!=0:
		get_node("Indicator0").queue_free()
	if place!=1:
		get_node("Indicator1").queue_free()
	if place!=2:
		get_node("Indicator2").queue_free()
	await get_tree().create_timer(0.1).timeout
	dragon = dr
	visible = true

func _process(_delta) -> void:
	if visible:
		position.x = player.position.x + (960 * parent.true_scalex/parent.true_scaley)
		if !is_instance_valid(dragon):
			self.queue_free()
		elif position.x >= min(dragon.position.x + dragon.dH.position.x, dragon.position.x + dragon.draPnts[0].x):
			self.queue_free()

func _on_danger_beep_finished() -> void:
	await get_tree().create_timer(0.27).timeout
	sound_player.play()

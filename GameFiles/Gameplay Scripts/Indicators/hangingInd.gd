extends Node2D

@onready var sound_player:AudioStreamPlayer2D = get_node("DangerBeep")
@onready var parent:Node2D = get_node("../")
@onready var player:CharacterBody2D = get_node("../Player")
@onready var hss:Node2D = get_node("../HangingStudioStuff")

func _ready() -> void:
	position.x = min(hss.position.x - 480 * sin(hss.get_node("Bars").rotation), player.position.x + (960 * parent.true_scalex/parent.true_scaley))
	position.y = 540 + (-270 * sin(hss.get_node("Bars").rotation - PI/2))
	visible = true

func _process(_delta) -> void:
	position.x = min(hss.position.x - 480 * sin(hss.get_node("Bars").rotation), player.position.x + (960 * parent.true_scalex/parent.true_scaley))
	position.y = 540 + (-270 * sin(hss.get_node("Bars").rotation - PI/2))
	if player.position.x > hss.position.x + 480:
		self.queue_free()

func _on_danger_beep_finished() -> void:
	await get_tree().create_timer(0.27).timeout
	sound_player.play()

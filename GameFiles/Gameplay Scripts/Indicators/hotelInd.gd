extends Node2D

@onready var sound_player:AudioStreamPlayer2D = get_node("DangerBeep")
@onready var parent:Node2D = get_node("../")
@onready var player:CharacterBody2D = get_node("../Player")
@onready var hotel:Node2D = get_node("../Hotel")

func _ready() -> void:
	if hotel.get_node("HotelPiece1").position.y != -360:
		get_node("Indicator0").queue_free()
	if hotel.get_node("HotelPiece1").position.y != 0:
		get_node("Indicator1").queue_free()
	if hotel.get_node("HotelPiece1").position.y != 360:
		get_node("Indicator2").queue_free()
	await get_tree().create_timer(0.1).timeout
	visible = true

func _process(_delta) -> void:
	position.x = player.position.x + (960 * parent.true_scalex/parent.true_scaley)
	if position.x > hotel.position.x - 736:
		self.queue_free()

func _on_danger_beep_finished() -> void:
	await get_tree().create_timer(0.27).timeout
	sound_player.play()

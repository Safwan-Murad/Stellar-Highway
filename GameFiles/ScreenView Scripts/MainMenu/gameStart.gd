extends Node2D

var mode:String
var noSpam:bool = true
var Utils:Node2D
@onready var score:Label = get_node("highScore")

func _ready() -> void:
	get_tree().paused = false
	set_process_input(true)
	Utils = get_tree().get_first_node_in_group("Utils")
	changeScore(0)

func _input(_ev:InputEvent) -> void:
	if Input.is_key_pressed(KEY_ENTER) and noSpam:
		_on_button_released()
		noSpam = false

func _on_button_released() -> void:
	get_node("Button").queue_free()
	get_node("Top2").get_node("AnimationPlayer").play("close")

func _on_animation_player_animation_finished(_anim_name:String) -> void:
	await get_tree().create_timer(0.5).timeout
	mode = get_node("../../LeftCenter/Gamemodes/Gamemodes").mode
	get_node("../../Center/Loading").loadStart(mode)

func changeScore(mode:int) -> void:
	var sc:int = 0
	if Utils.scores:
		if Utils.scores.has(str(mode)):
			sc = Utils.scores[str(mode)]
	score.text = "00000000".substr(str(sc).length()) + str(sc)

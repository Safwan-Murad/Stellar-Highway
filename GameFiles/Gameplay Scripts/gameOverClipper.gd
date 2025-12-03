extends Node2D

var bg_music := AudioStreamPlayer.new()

var score:int

func _ready() -> void:
	add_to_group("clipperBoy")
	bg_music.stream = load("res://GameFiles/OST/Gameplay/GG.mp3")

func myCondolences() -> void:
	bg_music.autoplay = true
	add_child(bg_music)
	get_node("Top2").get_node("AnimationPlayer").play("close")
	visible = true
	score = get_tree().get_first_node_in_group("Score").sc
	score += get_tree().get_first_node_in_group("Score").of
	get_node("highScore").text = "00000000".substr(str(score).length()) + str(score)

func _on_animation_player_animation_finished(_anim_name:String) -> void:
	await get_tree().create_timer(0.5).timeout


func _on_button_released() -> void:
	get_tree().change_scene_to_file("res://MainMenu.tscn")

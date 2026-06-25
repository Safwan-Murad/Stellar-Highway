extends Node2D
## The game-over screen — a film clapperboard that snaps shut on your final score.
##
## Reachable via the "clipperBoy" group. [method myCondolences] is the entry point the
## player calls on death: it plays the "GG" sting, closes the clapperboard, and prints the
## final score (distance + bonus), zero-padded. Its button returns to the main menu.

var bg_music := AudioStreamPlayer.new()

var score:int  ## The final score shown (distance + bonus).

func _ready() -> void:
	add_to_group("clipperBoy")
	bg_music.stream = load("res://GameFiles/OST/Gameplay/GG.mp3")

## Show the game-over screen with the final score. ("My condolences" — you died.)
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

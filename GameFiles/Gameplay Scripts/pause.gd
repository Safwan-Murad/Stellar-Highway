extends Button

var gameOn:bool = true
var jobman:bool = true
var pause:Resource = preload("res://GameFiles/SpinHead IMGS/UI/in-game/PauseBTN/PauseBTN.png")
var res:Resource = preload("res://GameFiles/SpinHead IMGS/UI/in-game/PauseBTN/ResBTN.png")
var rep:Resource = preload("res://GameFiles/SpinHead IMGS/UI/in-game/replayBTN/replayBTN.png")
@onready var muteBTN:Control = get_node("../../BottomRight")
@onready var repBTN:Control = get_node("../repBTN")
@onready var quitBTN:Control = get_node("../quitBTN")
@onready var anim:AnimationPlayer = get_node("AnimationPlayer")
@onready var ganim:AnimationPlayer = get_node("../AnimationPlayer")
@onready var Utils:Node2D = get_tree().get_first_node_in_group("Utils")
var noSpam:bool = true
var bg_music:AudioStreamPlayer
var stream:Resource
var disabledL:bool = false

func _ready() -> void:
	get_tree().paused = false
	stream = load("res://GameFiles/OST/Gameplay/PAUSE 192.mp3")
	add_to_group("pauseman")
	set_process_input(true)

func switchJobs():
	jobman = false
	self.icon = rep

func _input(_ev:InputEvent) -> void:
	if Input.is_key_pressed(KEY_P) and noSpam and jobman and not disabledL:
		_on_pressed()
		noSpam = false
		await get_tree().create_timer(0.25).timeout
		noSpam = true

func _on_pressed() -> void:
	if not disabledL:
		if jobman:
			if gameOn:
				get_tree().paused = true
				muteBTN.visible = true
				repBTN.visible = true
				quitBTN.visible = true
				ganim.play("cool_slide")
				self.icon = res
				bg_music = AudioStreamPlayer.new()
				bg_music.stream = stream
				bg_music.autoplay = true
				add_child(bg_music)
			else:
				get_tree().paused = false
				muteBTN.visible = false
				ganim.play_backwards("cool_slide")
				self.icon = pause
				bg_music.queue_free()
			gameOn = not gameOn
			get_tree().get_first_node_in_group("playerInput").is_pre = false
		else:
			get_tree().reload_current_scene()
		anim.play("onClick")

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if repBTN.position.y < 100:
		repBTN.visible = false
		quitBTN.visible = false

func saveAndStuff() -> void:
	Utils.savegame(get_tree().get_first_node_in_group("Player").currChar, get_tree().get_first_node_in_group("StarCnt").stars)
	var finalScore:int = get_tree().get_first_node_in_group("Score").sc
	finalScore += get_tree().get_first_node_in_group("Score").of
	Utils.saveScore(finalScore, get_tree().get_first_node_in_group("Player").gamemode)

func _on_rep_btn_pressed() -> void:
	if not disabledL:
		disabledL = true
		repBTN.get_node("AnimationPlayer").play("onClick")
		saveAndStuff()
		get_tree().reload_current_scene()

func _on_quit_btn_pressed() -> void:
	if not disabledL:
		disabledL = true
		quitBTN.get_node("AnimationPlayer").play("onClick")
		saveAndStuff()
		get_tree().change_scene_to_file("res://MainMenu.tscn")

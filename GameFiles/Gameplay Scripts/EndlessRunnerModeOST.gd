extends Node2D
## Root script of every game-mode scene: music + the mode index + back-button handling.
##
## Despite the name it runs for all three modes (the scene's root node has this script).
## It picks a random gameplay track, and — based on the scene's [code]name[/code] — sets the
## [code]gamemode[/code] index (0/1/2) on both the player and the sizeChange node. It also
## intercepts the Android back button / window close to pause instead of quitting.

var bg_music := AudioStreamPlayer.new()

func _ready() -> void:
	get_tree().set_auto_accept_quit(false)
	get_tree().set_quit_on_go_back(false)
	randomize()
	await get_tree().create_timer(1).timeout
	# Pick one of three gameplay tracks at random.
	var rand:int = randi() % 3
	if rand == 0:
		bg_music.stream = load("res://GameFiles/OST/Gameplay/Rollin' Blues 192.mp3")
	elif rand == 1:
		bg_music.stream = load("res://GameFiles/OST/Gameplay/Actionator 192.mp3")
	else:
		bg_music.stream = load("res://GameFiles/OST/Gameplay/Error! Error! ERROR! 192.mp3")
	bg_music.autoplay = true
	add_child(bg_music)
	
	if name == "EndlessRunnerMode":
		get_node("sizeChange/Player").gamemode = 0
		get_node("sizeChange").gamemode = 0
	elif name == "HoleIn-a-WallMode":
		get_node("sizeChange/Player").gamemode = 1
		get_node("sizeChange").gamemode = 1
	else:
		get_node("sizeChange/Player").gamemode = 2
		get_node("sizeChange").gamemode = 2

## Back button / window close during a run pauses the game instead of quitting.
func _notification(what) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if get_node("UI/TopRight/pauseBTN").gameOn:
			get_node("UI/TopRight/pauseBTN")._on_pressed()

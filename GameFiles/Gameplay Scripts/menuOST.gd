extends Node2D

var bg_music := AudioStreamPlayer.new()

func _ready() -> void:
	get_tree().set_auto_accept_quit(false)
	get_tree().set_quit_on_go_back(false)
	RenderingServer.set_default_clear_color(Color("#1a141c"))
	bg_music.stream = load("res://GameFiles/OST/Gameplay/SpinHead 192.mp3")
	bg_music.autoplay = true
	bg_music.process_mode = Node.PROCESS_MODE_ALWAYS
	
	add_child(bg_music)

func _notification(what:int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().quit()

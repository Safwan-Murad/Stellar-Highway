extends Node2D

@onready var inVideo:VideoStreamPlayer = get_node("CanvasLayer/Control/VideoStreamPlayer")

func _ready() -> void:
	get_tree().set_auto_accept_quit(false)
	get_tree().set_quit_on_go_back(false)
	RenderingServer.set_default_clear_color(Color(0, 0 , 0))
	get_node("AudioStreamPlayer").play()
	await get_tree().create_timer(0.25).timeout
	inVideo.play()

func _on_audio_stream_player_finished() -> void:
	await get_tree().create_timer(0.25).timeout
	get_tree().change_scene_to_file("res://MainMenu.tscn")

func _notification(what) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().quit()

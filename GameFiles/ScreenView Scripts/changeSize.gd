extends Node2D

var minimum_size:Vector2 = Vector2(1920, 1080)
var last_size:Vector2 = Vector2(1920, 1080)
var win_size:Vector2 = Vector2(1920, 1080)
var true_scalex:float = 1.0
var true_scaley:float = 1.0
var cameraOffx = [420, 420, 0]
var gamemode:int = 0

func _ready() -> void:
	add_to_group("Playfield")
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		win_size = DisplayServer.screen_get_size()
	else:
		win_size = DisplayServer.window_get_size()
		
	if win_size.x != last_size.x or win_size.y != last_size.y:
		if win_size.x/win_size.y > 1920.0/1080:
			changeSize()
		else:
			true_scalex = 1.0
			true_scaley = 1.0
	last_size.x = win_size.x
	last_size.y = win_size.y
	if get_node_or_null("Player"):
		get_node("Player/Camera2D").offset.x = cameraOffx[gamemode] * true_scalex/true_scaley
		get_node("../UI/Center/Loading").loadEnd()
	
func _process(_delta:float) -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		win_size = DisplayServer.screen_get_size()
	else:
		win_size = DisplayServer.window_get_size()
		
	if win_size.x != last_size.x or win_size.y != last_size.y:
		if win_size.x/win_size.y > 1920.0/1080:
			changeSize()
		else:
			true_scalex = 1.0
			true_scaley = 1.0
	last_size.x = win_size.x
	last_size.y = win_size.y
	if get_node_or_null("Player"):
		get_node("Player/Camera2D").offset.x = cameraOffx[gamemode] * true_scalex/true_scaley

func changeSize() -> void:
	true_scalex = win_size.x/minimum_size.x
	true_scaley = win_size.y/minimum_size.y

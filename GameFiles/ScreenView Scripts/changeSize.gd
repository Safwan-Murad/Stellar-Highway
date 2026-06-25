extends Node2D
## Aspect-ratio scaling for the whole playfield.
##
## The game renders at a fixed 1080 px height but a flexible width. This node (the
## "Playfield" group, parent of all gameplay nodes) watches the window size and, when
## the device is wider than 16:9, computes [member true_scalex]/[member true_scaley].
## Spawners multiply their horizontal spawn offsets by [code]true_scalex/true_scaley[/code]
## so obstacles always appear just past the right edge, on any screen.

var minimum_size:Vector2 = Vector2(Refs.SCREEN_WIDTH, Refs.SCREEN_HEIGHT)  ## The design resolution.
var last_size:Vector2 = Vector2(1920, 1080)     ## Window size seen last frame (to detect changes).
var win_size:Vector2 = Vector2(1920, 1080)      ## Current window/screen size.
var true_scalex:float = 1.0  ## Horizontal scale factor vs the design width.
var true_scaley:float = 1.0  ## Vertical scale factor vs the design height.
var cameraOffx = [420, 420, 0]  ## Per-mode camera X offset (Endless/Wall look ahead; Missiles is centred).
var gamemode:int = 0  ## 0 Endless, 1 Hole-in-a-Wall, 2 Missiles (set by the mode's OST script).

func _ready() -> void:
	add_to_group("Playfield")
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		win_size = DisplayServer.screen_get_size()
	else:
		win_size = DisplayServer.window_get_size()
		
	if win_size.x != last_size.x or win_size.y != last_size.y:
		if win_size.x/win_size.y > Refs.DESIGN_ASPECT:
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
		if win_size.x/win_size.y > Refs.DESIGN_ASPECT:
			changeSize()
		else:
			true_scalex = 1.0
			true_scaley = 1.0
	last_size.x = win_size.x
	last_size.y = win_size.y
	if get_node_or_null("Player"):
		get_node("Player/Camera2D").offset.x = cameraOffx[gamemode] * true_scalex/true_scaley

## Recomputes the scale factors from the current window size against the design size.
func changeSize() -> void:
	true_scalex = win_size.x/minimum_size.x
	true_scaley = win_size.y/minimum_size.y

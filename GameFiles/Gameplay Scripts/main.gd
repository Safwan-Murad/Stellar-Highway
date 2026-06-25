extends Node
## Small standalone helper: hides the mouse cursor and toggles fullscreen on F11.
##
## NOTE: this script is not currently attached to any scene in the project — it's a
## leftover/utility kept for desktop testing. (A custom hardware cursor is set in
## project.godot, so the OS cursor is hidden here to avoid showing both.)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

## Toggle between fullscreen and windowed when the "ui_full_screen" action (F11) is pressed.
func _process(delta):
	if Input.is_action_just_pressed("ui_full_screen"):
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (!((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))) else Window.MODE_WINDOWED

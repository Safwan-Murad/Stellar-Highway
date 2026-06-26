extends Control
## The main-menu settings popup. Opened from the shop view; Esc or its close button
## dismisses it. Keeps its dimming overlay sized to the current aspect ratio.

@onready var shady:Sprite2D = get_node("ShadyBusiness")  ## The dimming overlay behind the panel.

## The interactive controls (music/haptics/assist-draw), built as their own scene so they're easy
## to restyle in the editor. Added here so they live and hide together with this popup.
var Controls:Resource = preload("res://GameFiles/Sprites/UI/SettingsControls.tscn")

func _ready() -> void:
	visible = false
	set_process_input(true)
	add_child(Controls.instantiate())

func _process(_delta:float) -> void:
	var pf:Node = Refs.playfield()
	if pf:
		shady.scale.x = pf.true_scalex / pf.true_scaley

func _input(_ev:InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE) and visible:
		_on_close_btn_pressed()

func _on_close_btn_pressed() -> void:
	visible = false
	get_tree().paused = false

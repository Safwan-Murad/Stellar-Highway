extends Control

@onready var shady:Sprite2D = get_node("ShadyBusiness")

func _ready() -> void:
	visible = false
	set_process_input(true)

func _process(_delta:float) -> void:
	shady.scale.x = get_node("../../../sizeChange").true_scalex/get_node("../../../sizeChange").true_scaley

func _input(_ev:InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE) and visible:
		_on_close_btn_pressed()

func _on_close_btn_pressed() -> void:
	visible = false
	get_tree().paused = false

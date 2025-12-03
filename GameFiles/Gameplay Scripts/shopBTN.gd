extends Button

var gameOn:bool = true
var shop:Resource = preload("res://GameFiles/SpinHead IMGS/UI/menu/shopBTN/shopBTN.png")
var back:Resource = preload("res://GameFiles/SpinHead IMGS/UI/menu/shopBTN/shopBTN.png")
@onready var anim:AnimationPlayer = get_node("AnimationPlayer")
var noSpam:bool = true

@onready var menuStuff:Array[Node] = [get_node("../../BottomCenter/ClipperBoard"),
	get_node("../../../sizeChange/WindTurbine"),
	get_node("../../LeftCenter")
]

@onready var shopStuff:Array[Node] = [get_node("../../TopLeft")]

func _ready() -> void:
	set_process_input(true) 

func _input(_ev:InputEvent) -> void:
	if Input.is_key_pressed(KEY_S) and noSpam:
		_on_pressed()
		noSpam = false
		await get_tree().create_timer(0.25).timeout
		noSpam = true

func _on_pressed() -> void:
	if gameOn:
		get_node("../../../sizeChange/WindTurbine").position.x = get_node("../../../sizeChange/Restaurant1").position.x
		for obj in menuStuff:
			obj.visible = false
		for obj in shopStuff:
			obj.visible = true
		self.icon = back
	else:
		get_node("../../../sizeChange/WindTurbine").position.x = 960
		for obj in menuStuff:
			obj.visible = true
		for obj in shopStuff:
			obj.visible = false
		self.icon = shop
	gameOn = not gameOn
	anim.play("onClick")

func _on_tut_btn_pressed() -> void:
	get_node("../../Center/tutorialBook").visible = true
	get_node("../../Center/tutorialBook").getUrS___Right()
	get_tree().paused = true

func _on_settings_btn_pressed() -> void:
	get_node("../../Center/Settings").visible = true
	get_tree().paused = true

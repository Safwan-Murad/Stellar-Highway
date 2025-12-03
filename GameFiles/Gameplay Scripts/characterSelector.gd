extends Node2D

@onready var b:Array[Node] = get_children()
var noSpam:bool = true
var selectedChar:int = 0
@onready var Utils:Node2D = get_tree().get_first_node_in_group("Utils")
var loaded:bool = false
var ownedChars:Array = [1, 0, 0, 0, 0, 0]
var price:Array[int] = [0, 15000, 20000, 25000, 30000, 35000]
var stars:int = 0

func _ready() -> void:
	if Utils.loaded_data:
		if Utils.loaded_data.has("ownedChars"):
			ownedChars = Utils.loaded_data["ownedChars"]
		if Utils.loaded_data.has("playerCharacter"):
			selectedChar = int(Utils.loaded_data["playerCharacter"])
	if not ownedChars[selectedChar]:
		selectedChar = 0
	
	for i in range(ownedChars.size()):
		if ownedChars[i]:
			b[i].get_node("F").visible = false
			b[i].get_node("T0").visible = true
			b[i].get_node("T1").visible = false
		else:
			b[i].get_node("F").visible = true
			b[i].get_node("T0").visible = false
			b[i].get_node("T1").visible = false
	
	match selectedChar:
		0:
			_on_b_0_pressed()
		1:
			_on_b_1_pressed()
		2:
			_on_b_2_pressed()
		3:
			_on_b_3_pressed()
		4:
			_on_b_4_pressed()
		5:
			_on_b_5_pressed()
	
	set_process_input(true)

func _input(_ev:InputEvent) -> void:
	if noSpam:
		if Input.is_key_pressed(KEY_1):
			_on_b_0_pressed()
		elif Input.is_key_pressed(KEY_2):
			_on_b_1_pressed()
		elif Input.is_key_pressed(KEY_3):
			_on_b_2_pressed()
		elif Input.is_key_pressed(KEY_4):
			_on_b_3_pressed()
		elif Input.is_key_pressed(KEY_5):
			_on_b_4_pressed()
		elif Input.is_key_pressed(KEY_6):
			_on_b_5_pressed()
		noSpam = false
		await get_tree().create_timer(0.1).timeout
		noSpam = true

func generalPressed(btn:int) -> void:
	if get_node("../../WindTurbine").position.x < 3000 and loaded:
		return
	loaded = true
	if ownedChars[btn]:
		selectedChar = btn
		Utils.savegame(selectedChar)
		for i in range(6):
			if btn == i:
				b[i].get_node("F").visible = false
				b[i].get_node("T0").visible = false
				b[i].get_node("T1").visible = true
			elif ownedChars[i]:
				b[i].get_node("F").visible = false
				b[i].get_node("T1").visible = false
				b[i].get_node("T0").visible = true
	else:
		stars = get_tree().get_first_node_in_group("Stars").stars
		if stars >= price[btn]:
			ownedChars[btn] = 1
			get_tree().get_first_node_in_group("Stars").stars -= price[btn]
			Utils.savegame(selectedChar, -price[btn], ownedChars)
			generalPressed(btn)
	b[btn].get_node("AnimationPlayer").play("onClick")

func _on_b_0_pressed() -> void:
	generalPressed(0)

func _on_b_1_pressed() -> void:
	generalPressed(1)

func _on_b_2_pressed() -> void:
	generalPressed(2)

func _on_b_3_pressed() -> void:
	generalPressed(3)

func _on_b_4_pressed() -> void:
	generalPressed(4)

func _on_b_5_pressed() -> void:
	generalPressed(5)

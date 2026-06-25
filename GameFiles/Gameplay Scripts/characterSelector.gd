extends Node2D
## The shop / character picker on the main menu.
##
## Manages the six character buttons. Each shows one of three states: locked ("F"),
## owned-but-not-selected ("T0"), or selected ("T1"). Tapping an owned character selects
## and saves it; tapping a locked one buys it if you can afford it (then selects it).
## Keys 1-6 are shortcuts.

@onready var b:Array[Node] = get_children()  ## The six character buttons.
var noSpam:bool = true       ## Debounce so a key press doesn't fire many frames in a row.
var selectedChar:int = 0     ## Index (0-5) of the equipped character.
@onready var Utils:Node2D = get_tree().get_first_node_in_group("Utils")
var loaded:bool = false      ## Set after the first interaction (guards the menu-transition check).
var ownedChars:Array = [1, 0, 0, 0, 0, 0]  ## Which characters are unlocked (0 is free).
var price:Array[int] = [0, 15000, 20000, 25000, 30000, 35000]  ## Star cost per character.
var stars:int = 0            ## Scratch: the player's balance when attempting a purchase.

## Load saved ownership and selection, set each button's locked/owned/selected art accordingly,
## then re-select the saved character so its preview is shown.
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

## Handles a press on character [param btn]: select it if owned, otherwise try to buy it
## (and select on success). Ignored unless the shop is open. Saves after any change.
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

extends Sprite2D
## The main-menu game-mode picker.
##
## Tracks which mode is selected (its scene path is exposed as [member mode], which
## gameStart.gd reads when launching). Updates the three buttons' highlighted icons and
## the high-score clapperboard when the selection changes. Keys 1/2/3 are shortcuts.

## The three selectable mode scenes, in button order.
var modes:Array[String] = ["res://GameFiles/Modes/EndlessRunnerMode.tscn",
	"res://GameFiles/Modes/HoleIn-a-WallMode.tscn",
	"res://GameFiles/Modes/MissilesMode.tscn"
]
var mode:String = modes[0]  ## The currently selected mode's scene path.

var textures:Array = [
	[
		preload("res://GameFiles/SpinHead IMGS/UI/menu/gamemodeMenu/endless/f.png"),
		preload("res://GameFiles/SpinHead IMGS/UI/menu/gamemodeMenu/endless/t.png")
	],
	[
		preload("res://GameFiles/SpinHead IMGS/UI/menu/gamemodeMenu/batWalls/f.png"),
		preload("res://GameFiles/SpinHead IMGS/UI/menu/gamemodeMenu/batWalls/t.png")
	],
	[
		preload("res://GameFiles/SpinHead IMGS/UI/menu/gamemodeMenu/missiles/f.png"),
		preload("res://GameFiles/SpinHead IMGS/UI/menu/gamemodeMenu/missiles/t.png")
	]
]

@onready var btns:Array[Node] = get_parent().get_children()
@onready var clipperBoi:Node2D = get_node("../../../BottomCenter/ClipperBoard")
var noSpam:bool = true

func _ready() -> void:
	set_process_input(true) 

func _input(_ev:InputEvent) -> void:
	if noSpam:
		if Input.is_key_pressed(KEY_1):
			_on_endless_btn_pressed()
		elif Input.is_key_pressed(KEY_2):
			_on_batwalls_btn_pressed()
		elif Input.is_key_pressed(KEY_3):
			_on_missiles_btn_pressed()
		noSpam = false
		await get_tree().create_timer(0.1).timeout
		noSpam = true

## Selects mode [param btn] (0-2): updates [member mode], the high-score board, and the
## button icons. Ignored while the shop is open (the wind turbine is parked off to the side).
func generalPressed(btn:int) -> void:
	if get_node("../../../../sizeChange/WindTurbine").position.x > 3000:
		return
	mode = modes[btn]
	clipperBoi.changeScore(btn)
	for i in range(3):
		if btn == i:
			btns[i+1].icon = textures[i][1]
		else:
			btns[i+1].icon = textures[i][0]
	get_node("../AnimationPlayer").play("on_click")

func _on_endless_btn_pressed() -> void:
	generalPressed(0)

func _on_batwalls_btn_pressed() -> void:
	generalPressed(1)

func _on_missiles_btn_pressed() -> void:
	generalPressed(2)

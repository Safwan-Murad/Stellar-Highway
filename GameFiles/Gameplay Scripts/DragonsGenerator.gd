extends Node2D
## Spawns the decorative dragons that fly across the main menu background.
##
## Not a gameplay obstacle — these are [code]MenuDragon[/code]s purely for flavour.
## It keeps a pair of dragons drifting across and respawns them once they've left.

var Dragon:Resource = preload("res://GameFiles/Sprites/Obstacles/Dragon/MenuDragon.tscn")

var obj:Node
var ready2spawn:bool = true
@onready var parent:Node2D = get_node("../")

var dragons_info:Array[int] = [400, 760]  ## The two Y rows the dragons fly along.

func _ready() -> void:
	randomize()

## Spawn a pair of menu dragons; respawn once the previous ones have flown off.
func _process(_delta:float) -> void:
	if ready2spawn:
		ready2spawn = false
		for i in range(2):
			obj = Dragon.instantiate()
			obj.position.x = 960 + 1080 * parent.true_scalex/parent.true_scaley
			obj.position.y = dragons_info[i] + randi() % 180
			obj.chx = -(16 + randi() % 9)
			if randi()%2:
				obj.position.x = 960 - obj.position.x
				obj.chx = -obj.chx
			parent.add_child(obj)
	elif !is_instance_valid(obj):
		ready2spawn = true

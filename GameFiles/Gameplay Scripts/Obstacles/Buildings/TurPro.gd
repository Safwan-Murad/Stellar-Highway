extends Node2D
## A wind-turbine building: roll through the gap in the spinning blades, not into the tower.
##
## Picks one of two blade configurations and a random height (except on the main menu, where
## it's the fixed "shop" prop). The blades only annoy you; the tower's sides are lethal.
## ("TurPro" = the turbine prop; the spinning blades themselves are TurBlades.gd.)

static var offx:int = 348  ## Despawn clearance distance used by ObstacleGenerator.

func _ready() -> void:
	randomize()
	if get_node("../../").name != "MainMenu":
		position.y = 475 + randi() % 76
	# Keep one of the two blade sets, drop the other.
	var temp:int = randi() % 2
	if temp:
		get_node("Blades0").queue_free()
	else:
		get_node("Blades1").queue_free()

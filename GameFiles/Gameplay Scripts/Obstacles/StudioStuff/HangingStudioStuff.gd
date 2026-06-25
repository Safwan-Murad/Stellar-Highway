extends Node2D
## The "Broken Stage Bars": a set of bars hanging at a random swing angle. Touching them is lethal.
##
## Picks a random tilt (left or right) for the bars and triggers the hanging-stuff danger
## indicator so the player can see where the bars reach.

static var offx:int = 1024  ## Despawn clearance distance used by ObstacleGenerator.

func _ready() -> void:
	position.y = 540
	randomize()
	# Tilt the bars left or right by a random angle near horizontal.
	if randi() % 2:
		get_node("Bars").rotation = randf_range(PI - 0.28, PI - 0.028)
	else:
		get_node("Bars").rotation = -randf_range(PI - 0.28, PI - 0.028)
	get_node("../indicatorManager").indicateHSS()

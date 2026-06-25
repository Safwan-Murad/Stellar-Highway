extends Node2D
## A cluster of airships drifting across the sky. Touching any of them is lethal.
##
## Randomly removes one or two of its three airships for variety, gives each a random drift
## speed (via Move.gd), and triggers the airship danger indicator. [member offx] tells the
## generator how far past this node the player must travel before it's safe to despawn.

static var offx:int = 1920  ## Despawn clearance distance used by ObstacleGenerator.

func _ready() -> void:
	position.y = 0
	randomize()
	get_child(randi() % 3).queue_free()
	if randi() % 2:
		get_child(randi() % 2).queue_free()
	await get_tree().create_timer(0.1).timeout
	get_node("../indicatorManager").indicateAirships()
	
	for child in get_children():
		child.velocity = randf_range(3.0, 7.0)

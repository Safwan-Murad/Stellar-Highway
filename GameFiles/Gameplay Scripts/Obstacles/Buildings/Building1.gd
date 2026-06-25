extends StaticBody2D
## A fixed-art rooftop building you roll across. Walkable on top, lethal from the side.
##
## Spawns at a random height and may keep or drop its optional speed-boost pad. [member offx]
## is the despawn clearance the generator uses.

static var offx:int = 158  ## Despawn clearance distance used by ObstacleGenerator.

func _ready() -> void:
	randomize()
	position.y = 711 + randi() % 250
	# Keep the speed-boost pad only half the time, for variety.
	if get_node_or_null("SpeedBooster"):
		if randi() % 2:
			get_node("SpeedBooster").queue_free()

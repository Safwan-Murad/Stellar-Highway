extends StaticBody2D
## A rooftop building that may carry a random powerup (same scheme as Building2, different art).
##
## Randomises its height, optionally drops its spotlights and its two speed pads, and one time
## in ten per powerup type places a single powerup the player doesn't already hold.

static var offx:int = 1010  ## Despawn clearance distance used by ObstacleGenerator.

var Rockstar:Resource = preload("res://GameFiles/Sprites/Powerups/RockstarGuitar.tscn")
var Jetpack:Resource = preload("res://GameFiles/Sprites/Powerups/Jetpack.tscn")
var Dopel:Resource = preload("res://GameFiles/Sprites/Powerups/Doppelgänger.tscn")
var Umbrella:Resource = preload("res://GameFiles/Sprites/Powerups/Umbrella.tscn")
var Lowrider:Resource = preload("res://GameFiles/Sprites/Powerups/Lowrider.tscn")
var Powerup:Node2D

func _ready() -> void:
	randomize()
	position.y = 691 + randi() % 241 
	if randi() % 2:
		get_node("LightProjector").queue_free()
		get_node("LightProjector2").queue_free()
	for i in range(2):
		if randi() % 3 != 0:
			get_node("SpeedBooster" + str(i)).queue_free()

	# 0-4 each pick a powerup (if not already held); 5-9 leave the roof empty.
	match randi() % 10:
		0:
			if not get_tree().get_nodes_in_group("PowerupPopUps")[1].visible:
				Powerup = Rockstar.instantiate()
				addPU()
		1:
			if not get_tree().get_nodes_in_group("PowerupPopUps")[2].visible:
				Powerup = Jetpack.instantiate()
				addPU()
		2:
			if not get_tree().get_nodes_in_group("PowerupPopUps")[3].visible:
				Powerup = Dopel.instantiate()
				addPU()
		3:
			if not get_tree().get_nodes_in_group("PowerupPopUps")[4].visible:
				Powerup = Umbrella.instantiate()
				addPU()
		4:
			if not get_tree().get_nodes_in_group("PowerupPopUps")[5].visible:
				Powerup = Lowrider.instantiate()
				addPU()

## Place the chosen powerup at this building's roof spot.
func addPU() -> void:
	Powerup.position = Vector2(-16, -155)
	add_child(Powerup)

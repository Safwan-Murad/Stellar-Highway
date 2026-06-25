extends StaticBody2D
## A rooftop restaurant that may carry a random powerup (same scheme as Building2, different art).
##
## Randomises its height, optionally drops its speed pad, and one time in ten per powerup type
## places a single powerup the player doesn't already hold.

static var offx:int = 548  ## Despawn clearance distance used by ObstacleGenerator.

var Rockstar:Resource = preload("res://GameFiles/Sprites/Powerups/RockstarGuitar.tscn")
var Jetpack:Resource = preload("res://GameFiles/Sprites/Powerups/Jetpack.tscn")
var Dopel:Resource = preload("res://GameFiles/Sprites/Powerups/Doppelgänger.tscn")
var Umbrella:Resource = preload("res://GameFiles/Sprites/Powerups/Umbrella.tscn")
var Lowrider:Resource = preload("res://GameFiles/Sprites/Powerups/Lowrider.tscn")
var Powerup:Node2D

func _ready() -> void:
	randomize()
	position.y = 600 + randi() % 351
	if randi() % 2:
		get_node("SpeedBooster").queue_free()

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
	Powerup.position = Vector2(0, -239)
	add_child(Powerup)

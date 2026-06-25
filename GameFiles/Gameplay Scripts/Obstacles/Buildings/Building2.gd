extends StaticBody2D
## A rooftop building that may carry a random powerup. Walkable on top, lethal from the side.
##
## On spawn it randomises its height, optionally drops its decorative spotlights and speed pad,
## and — one time in ten per powerup type — places a single powerup on the roof (skipping any
## powerup the player already holds). [method addPU] positions it. (Building3 and Restaurant1
## follow the same pattern with different art and roof offsets.)

static var offx:int = 1105  ## Despawn clearance distance used by ObstacleGenerator.

var Rockstar:Resource = preload("res://GameFiles/Sprites/Powerups/RockstarGuitar.tscn")
var Jetpack:Resource = preload("res://GameFiles/Sprites/Powerups/Jetpack.tscn")
var Dopel:Resource = preload("res://GameFiles/Sprites/Powerups/Doppelgänger.tscn")
var Umbrella:Resource = preload("res://GameFiles/Sprites/Powerups/Umbrella.tscn")
var Lowrider:Resource = preload("res://GameFiles/Sprites/Powerups/Lowrider.tscn")
var Powerup:Node2D

func _ready() -> void:
	randomize()
	position.y = 674 + randi() % 201
	if randi() % 2:
		get_node("LightProjector").queue_free()
		get_node("LightProjector2").queue_free()
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
	Powerup.position = Vector2(817.5, -269)
	add_child(Powerup)

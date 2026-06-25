extends Node2D
## Clears the starting platform once the Missiles-mode fight begins.
##
## When the run starts, this slides the starting building (and itself) downward off
## the screen so the player is left in open space for the missile waves, then frees both.

@onready var player:CharacterBody2D = get_node("../Player")
@onready var building:StaticBody2D = get_node("../Building1")

func _process(_delta:float) -> void:
	if player.minSpeed > 0:
		position.y += 3
		building.position.y += 3
		
	if position.y >= 800:
		building.queue_free()
		self.queue_free()

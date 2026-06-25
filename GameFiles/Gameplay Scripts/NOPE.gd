extends StaticBody2D
## Invisible ceiling guard that keeps the player from flying off the top.
##
## It tracks the player horizontally and, if the player rises above the top edge,
## shoves them back down and kills upward velocity — a hard "NOPE" on leaving the screen.

@onready var player:CharacterBody2D = get_node("../Player")

func _ready() -> void:
	position.y = -30

func _process(_delta:float) -> void:
	position.x = player.position.x
	if player.position.y <= 4:
		player.position.y += 16
		player.velocity.y = 0

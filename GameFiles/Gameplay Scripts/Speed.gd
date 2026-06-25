extends Label
## HUD label that shows the player's current speed each frame.

@onready var player:CharacterBody2D = get_tree().get_first_node_in_group("Player")

func _process(_delta:float) -> void:
	text = str(player.vel)

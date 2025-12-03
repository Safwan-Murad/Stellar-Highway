extends Label

@onready var player:CharacterBody2D = get_tree().get_first_node_in_group("Player")

func _process(_delta:float) -> void:
	text = str(player.vel)

extends StaticBody2D

@onready var player:CharacterBody2D = get_node("../Player")
@onready var parent:Node2D = get_node("../")

func _process(_delta:float) -> void:
	position.x = max(player.position.x - 400 - 1920 * parent.true_scalex/parent.true_scaley * 2.7, position.x)

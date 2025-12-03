extends StaticBody2D

@onready var player:CharacterBody2D = get_node("../Player")

func _ready() -> void:
	position.y = -30

func _process(_delta:float) -> void:
	position.x = player.position.x
	if player.position.y <= 4:
		player.position.y += 16
		player.velocity.y = 0

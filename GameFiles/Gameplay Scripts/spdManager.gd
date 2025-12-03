extends Node2D

@onready var player:CharacterBody2D = get_node("../Player")
var offset:int

func _ready() -> void:
	offset = player.position.x

func _process(_delta:float) -> void:
	if player.minSpeed > 0:
		player.minSpeed = min(400 + (player.position.x - offset)/300, 1400)
		player.TOPROLL = 3 * (player.minSpeed + player.spdOffset)
		if player.minSpeed >= 1400:
			self.queue_free()

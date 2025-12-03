extends Node2D

var BatWall:Resource = preload("res://GameFiles/Sprites/Obstacles/WalloBats/BatWall.tscn")

@onready var player:CharacterBody2D = get_node("../Player")
var wall:Node2D
var ready2spawn:bool = true
var gameStart:bool = false
var spawned:int = 0
@onready var parent:Node2D = get_node("../")

func _ready() -> void:
	randomize()
	player.position.y = get_node("../Building1").position.y - 321
	get_node("../../UI/Center/Loading").loadEnd()

func _process(_delta:float) -> void:
	if gameStart:
		if ready2spawn:
			ready2spawn = false
			wall = BatWall.instantiate()
			wall.position.x = player.position.x + 64 + 1920 * parent.true_scalex/parent.scale.y * 0.8
			wall.wall_dist = max(1920 - spawned * 25, 1080)
			wall.difficulty = 1 + min(spawned * 0.1, 2)
			spawned += 1
			parent.add_child(wall)
		
		else:
			if player.position.x > wall.position.x + wall.offx + 1920 * parent.true_scalex/parent.scale.y * 0.4:
				ready2spawn = true
				wall.queue_free()

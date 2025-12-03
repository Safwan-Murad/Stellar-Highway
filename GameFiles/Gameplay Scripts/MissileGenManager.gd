extends Node2D

var rockets:Array[Resource] = [
	preload("res://GameFiles/Sprites/Obstacles/Missile.tscn"),
	preload("res://GameFiles/Sprites/Obstacles/TimedMissile.tscn")
]

@onready var tree:SceneTree = get_tree()
@onready var player:CharacterBody2D = get_node("../Player")
@onready var parent:Node2D = get_node("../")
var obj:CharacterBody2D
var wave:int = 1
var temp:int
var tempf:float
var ms:bool = false
var tms:bool = false

var MissileMark:Resource = preload("res://GameFiles/Sprites/Obstacles/MissileMark.tscn")
var TMissileMark:Resource = preload("res://GameFiles/Sprites/Obstacles/TMissileMark.tscn")

func _ready() -> void:
	randomize()
	player.position.y = get_node("../Building1").position.y - 321

func start() -> void:
	while true:
		tree.get_first_node_in_group("PowerupPopUps").text = "Wave " + str(wave)
		tree.get_first_node_in_group("PowerupPopUps").get_child(0).play("PopUp")
		await tree.create_timer(4.25).timeout
		tree.get_first_node_in_group("PowerupPopUps").text = ""
		for i in range(wave * 2):
			temp = randi() % 2
			obj = rockets[temp].instantiate()
			if temp:
				tms = true
			else:
				ms = true
			if randi() % 2:
				tempf = player.position.x + 64 + 1920 * parent.true_scalex/parent.scale.y
				obj.position.x = randf_range(-tempf, tempf)
				if randi() % 2:
					obj.position.y = -64
				else:
					obj.position.y = 1144
			else:
				if randi() % 2:
					obj.position.x = player.position.x + 64 + 1920 * parent.true_scalex/parent.scale.y * 0.8
				else:
					obj.position.x = -(player.position.x + 64 + 1920 * parent.true_scalex/parent.scale.y * 0.5)
				obj.position.y = randf_range(-1144, 1144)
			parent.add_child(obj)
		if ms and not get_node_or_null("../MissileMark"):
			parent.add_child(MissileMark.instantiate())
		if tms and not get_node_or_null("../TMissileMark"):
			parent.add_child(TMissileMark.instantiate())
		ms = false
		tms = false
		await tree.create_timer(min(7 + wave, 17)).timeout
		get_tree().get_first_node_in_group("Score").score += wave * 2000
		get_tree().get_first_node_in_group("StarCnt").stars += wave * 20
		wave += 1

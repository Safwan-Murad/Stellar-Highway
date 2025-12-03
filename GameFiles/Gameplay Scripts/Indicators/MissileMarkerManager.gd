extends Node2D

var Arrow:Resource = preload("res://GameFiles/Sprites/Indicators/MissileInd.tscn")

@onready var parent:Node2D = get_node("../")
@onready var player:CharacterBody2D = get_node("../Player")
var missiles:Array[Node]
var arrows:Array[Node]
var iters:int

func _process(_delta: float) -> void:
	missiles = get_tree().get_nodes_in_group("GMissiles")
	iters = max(arrows.size(), missiles.size())
	for i in range(iters):
		if i < missiles.size() and i < arrows.size():
			snitch(arrows[i], missiles[i])
		elif i >= arrows.size() and i < missiles.size():
			arrows.push_back(Arrow.instantiate())
			snitch(arrows[i], missiles[i])
			parent.add_child(arrows[i])
		elif i >= missiles.size():
			arrows.pop_back().queue_free()

func snitch(snitch:Node, victim:Node):
	snitch.position.x = player.position.x + (700 * parent.true_scalex/parent.true_scaley * (victim.position - player.position).normalized().x)
	snitch.position.y = min(max(victim.position.y, 80), 1000)
	snitch.look_at(victim.position)

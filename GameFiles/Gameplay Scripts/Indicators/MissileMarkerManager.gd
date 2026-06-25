extends Node2D
## Keeps an on-screen arrow pointing at every live missile (off-screen or on).
##
## Each frame it reconciles a pool of arrows with the current missiles (the "GMissiles" group):
## one arrow per missile, spawning/freeing as the count changes. Each arrow is pinned to a ring
## around the player and rotated to point at its missile, so you always know where threats are.

var Arrow:Resource = preload("res://GameFiles/Sprites/Indicators/MissileInd.tscn")

@onready var parent:Node2D = get_node("../")
@onready var player:CharacterBody2D = get_node("../Player")
var missiles:Array[Node]  ## All live missiles this frame.
var arrows:Array[Node]    ## The pool of arrows, one per missile.
var iters:int             ## max(arrows, missiles) — how many slots to reconcile this frame.

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

## Pin [param snitch] (an arrow) to the ring around the player and aim it at [param victim] (a
## missile). ("snitch" because the arrow tells on the missile's location.)
func snitch(snitch:Node, victim:Node):
	snitch.position.x = player.position.x + (700 * parent.true_scalex/parent.true_scaley * (victim.position - player.position).normalized().x)
	snitch.position.y = min(max(victim.position.y, 80), 1000)
	snitch.look_at(victim.position)

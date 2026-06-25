extends Node2D
## Spawns and recycles the world ahead of the player in Endless Runner mode.
##
## Keeps roughly one obstacle on screen at a time. Each frame, when ready, it picks a
## random obstacle, places it just past the right edge (scaled by the playfield's
## aspect ratio), and waits until the player has rolled past before freeing it and
## spawning the next. The pool of allowed obstacles grows with distance ([member spawned]),
## which is the game's difficulty curve. Dragons (index 12) and missiles (11/14) have
## bespoke multi-spawn logic and report progress via [member snapshot] instead.

## Every obstacle scene, indexed by the numbers used in the match statements below.
var objs:Array[Resource] = [
	preload("res://GameFiles/Sprites/Obstacles/Buildings/Building1.tscn"),
	preload("res://GameFiles/Sprites/Obstacles/Buildings/Building2.tscn"),
	preload("res://GameFiles/Sprites/Obstacles/Buildings/Building3.tscn"),
	preload("res://GameFiles/Sprites/Obstacles/Buildings/Restaurant1.tscn"),
	preload("res://GameFiles/Sprites/Obstacles/Buildings/RandomBuilding/RandomBuilding.tscn"),
	preload("res://GameFiles/Sprites/Obstacles/Buildings/UnderConstruction/UnderConstruction.tscn"),
	preload("res://GameFiles/Sprites/Obstacles/Hotel/Hotel.tscn"),
	preload("res://GameFiles/Sprites/Obstacles/Airships.tscn"),
	preload("res://GameFiles/Sprites/Obstacles/HangingStudioStuff.tscn"),
	preload("res://GameFiles/Sprites/Obstacles/StudioStuff.tscn"),
	preload("res://GameFiles/Sprites/Obstacles/Buildings/RandomBuilding/RandomBuilding2.tscn"),
	preload("res://GameFiles/Sprites/Obstacles/Missile.tscn"),
	preload("res://GameFiles/Sprites/Obstacles/Dragon/Dragon.tscn"),
	preload("res://GameFiles/Sprites/Obstacles/Buildings/WindTurbine.tscn"),
	preload("res://GameFiles/Sprites/Obstacles/TimedMissile.tscn"),
	preload("res://GameFiles/Sprites/Obstacles/WalloBats/BatWall.tscn")
]
var MissileMark:Resource = preload("res://GameFiles/Sprites/Obstacles/MissileMark.tscn")
var TMissileMark:Resource = preload("res://GameFiles/Sprites/Obstacles/TMissileMark.tscn")

@onready var player:CharacterBody2D = get_node("../Player")
@onready var indMan:Node2D = get_node("../indicatorManager")
var obj:Node
var objIdx:int
var ready2spawn:bool = true
var spawned:int = 0
var snapshot:int
@onready var parent:Node2D = get_node("../")

var dragons_info:Array[int] = [100, 460, 820]   ## Candidate Y rows for a flock of dragons.
var dragons_info1:Array[int] = [-36, 1116]       ## Candidate Y rows for a single big dragon.
var why:Array[int] = [64, 64, -64, -64]          ## Per-rocket X nudges for a missile volley.
var rockets_info:Array[Vector2] = [Vector2(0.8, 900), Vector2(0.8, 180), Vector2(-0.4, 900), Vector2(-0.4, 180)]  ## (X factor, Y) per rocket.
var nums:int     ## How many objects to spawn in a multi-spawn group this round.
var offset:int   ## Random starting index into the layout arrays.
var rand:Array[int] = [0, 0]  ## Which rows were chosen (kept to drive the indicators).

func _ready() -> void:
	randomize()
	# Drop the player onto the top of the starting building, then end the load animation.
	player.position.y = get_node("../Building1").position.y - 321
	get_node("../../UI/Center/Loading").loadEnd()

## When ready, pick and place the next obstacle; otherwise watch for the player to
## pass the current one and mark ready again.
func _process(_delta:float) -> void:
	if ready2spawn:
		# Pick within a window that widens with distance, unlocking harder obstacles over time.
		objIdx = randi() % (4 + (spawned/2))
		if 4 + spawned/2 < objs.size():
			spawned += 1
		ready2spawn = false
		match objIdx:
			# Single ground/building obstacles: spawn one just off the right edge.
			0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 13:
				obj = objs[objIdx].instantiate()
				obj.position.x = player.position.x + obj.offx + 1920 * parent.true_scalex/parent.true_scaley * 0.8
				parent.add_child(obj)
			# Dragons: either a flock at random rows or one large dragon.
			12:
				if randi() % 3 != 0:
					snapshot = player.position.x + 2880 * parent.true_scalex/parent.true_scaley + 240
					nums = randi() % 2 + 1
					offset = randi() % 3
					rand[1] = 10
					for i in range(nums):
						obj = objs[objIdx].instantiate()
						obj.position.x = player.position.x + 2880 * parent.true_scalex/parent.true_scaley
						rand[i] = (i+offset)%3
						obj.position.y = dragons_info[rand[i]] + randi() % 160
						obj.offx = 1.4 * 1920 * parent.true_scalex/parent.true_scaley
						parent.add_child(obj)
						indMan.indicateDragons(rand[i], obj)
				else:
					snapshot = player.position.x + 2420 * parent.true_scalex/parent.true_scaley + 240
					obj = objs[objIdx].instantiate()
					obj.position.x = player.position.x + 2420 * parent.true_scalex/parent.true_scaley * 0.8
					rand[0] = randi()%2
					obj.position.y = dragons_info1[rand[0]]
					obj.d_ch = 6 + randi() % 7
					if obj.position.y > 540:
						obj.d_ch*=-1
					obj.offx = 1.4 * 2420 * parent.true_scalex/parent.true_scaley
					parent.add_child(obj)
					indMan.indicateDragons(2*rand[0], obj)
			# Missile volleys (11 = lock-on, 14 = timed): spawn a cluster + its warning marker.
			11, 14:
				snapshot = player.position.x + 1920 * parent.true_scalex/parent.true_scaley + 240
				nums = randi() % 4 + 1
				offset = randi() % (5 - nums)
				for i in range(nums):
					obj = objs[objIdx].instantiate()
					obj.position.x = player.position.x + why[i+offset] + 1920 * parent.true_scalex/parent.true_scaley * rockets_info[i+offset].x
					obj.position.y = rockets_info[i+offset].y
					parent.add_child(obj)
				if objIdx == 11 and not get_node_or_null("../MissileMark"):
					parent.add_child(MissileMark.instantiate())
				if objIdx == 14 and not get_node_or_null("../TMissileMark"):
					parent.add_child(TMissileMark.instantiate())
			15:
				obj = objs[objIdx].instantiate()
				obj.position.x = player.position.x + 64 + 1920 * parent.true_scalex/parent.true_scaley * 0.8
				parent.add_child(obj)
			# Index rolled outside the spawnable set this round: just try again next frame.
			_:
				ready2spawn = true

	else:
		# Waiting for the current obstacle to be cleared before spawning the next.
		match objIdx:
			0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 13, 15:
				if player.position.x > obj.position.x + obj.offx + 1920 * parent.true_scalex/parent.true_scaley * 0.4:
					ready2spawn = true
					obj.queue_free()
			# Multi-spawn groups self-despawn; we just watch the saved snapshot X.
			11, 12, 14:
				if player.position.x > snapshot:
					ready2spawn = true

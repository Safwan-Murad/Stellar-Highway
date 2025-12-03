extends Node2D

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

var dragons_info:Array[int] = [100, 460, 820]
var dragons_info1:Array[int] = [-36, 1116]
var why:Array[int] = [64, 64, -64, -64]
var rockets_info:Array[Vector2] = [Vector2(0.8, 900), Vector2(0.8, 180), Vector2(-0.4, 900), Vector2(-0.4, 180)]
var nums:int
var offset:int
var rand:Array[int] = [0, 0]

func _ready() -> void:
	randomize()
	player.position.y = get_node("../Building1").position.y - 321
	get_node("../../UI/Center/Loading").loadEnd()

func _process(_delta:float) -> void:
	if ready2spawn:
		objIdx = randi() % (4 + (spawned/2))
		if 4 + spawned/2 < objs.size():
			spawned += 1
		ready2spawn = false
		match objIdx:
			0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 13:
				obj = objs[objIdx].instantiate()
				obj.position.x = player.position.x + obj.offx + 1920 * parent.true_scalex/parent.true_scaley * 0.8
				parent.add_child(obj)
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
			_:
				ready2spawn = true
				
	else:
		match objIdx:
			0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 13, 15:
				if player.position.x > obj.position.x + obj.offx + 1920 * parent.true_scalex/parent.true_scaley * 0.4:
					ready2spawn = true
					obj.queue_free()
			11, 12, 14:
				if player.position.x > snapshot:
					ready2spawn = true

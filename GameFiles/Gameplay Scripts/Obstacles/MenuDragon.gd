extends StaticBody2D

var dP:Resource = preload("res://GameFiles/Sprites/Obstacles/Dragon/dragonPiece.tscn")
@onready var dH:Sprite2D = get_node("DragonHead")
@onready var dB:Line2D = get_node("DragonBody")
var draPnts:PackedVector2Array = []
var draP:Array = []
var stTemp:Node2D
var x:float = 0.0
var cnt:float = 0.0
var dir:int
var headPump:float = 0.6
@export var mxSize:int = 128
@export var timeman:float = 0.02
@export var chx:int = -8
@export var verticality:int = 64
var draSize:int
var killme:bool = true
var sin_step:float = 0.2
@onready var parent:Node2D = get_node("../")

func _ready() -> void:
	randomize()
	mxSize = 32 + randi() % 97
	verticality = 64 + randi() % 65
	headPump = verticality / 128.0
	timeman = randf_range(0.03, 0.05)
	sin_step = randf_range(0.1, 0.3)
	if chx > 0:
		dir = 1
		get_node("DragonHead").flip_h = true
	else:
		dir = -1
		get_node("DragonHead").flip_h = false
		get_node("DragonBody").texture = preload("res://GameFiles/SpinHead IMGS/Dragon/dragonPieceFlipped.png")
	
func _process(delta:float) -> void:
	cnt += delta
	if cnt >= timeman:
		cnt = 0.0
		
		draPnts = dB.points
		draPnts.push_back(Vector2(draPnts[draPnts.size()-1].x + chx, verticality*sin(x)))
		x += sin_step
		
		dH.position = draPnts[draPnts.size()-1] + Vector2(24 * dir, 16)
		dH.rotation = sin(x + dir*PI/4) * headPump
		
		if draPnts.size() > mxSize:
			draPnts.remove_at(0)
		else:
			draP.push_back(dP.instantiate())
			add_child(draP.back())
			draP.back().get_node("CollisionShape2D").shape = SegmentShape2D.new()
			
		dB.set_points(draPnts)
		for i in range(draP.size()):
			draP[i].get_node("CollisionShape2D").shape.b = draPnts[i]
			draP[i].get_node("CollisionShape2D").shape.a = draPnts[i+1]
			
	if draPnts.size():
		if chx < 0 && position.x + draPnts[0].x <= -1080 * parent.true_scalex/parent.true_scaley:
			self.queue_free()
		elif chx > 0 && position.x + draPnts[0].x >= 960 + 1080 * parent.true_scalex/parent.true_scaley:
			self.queue_free()

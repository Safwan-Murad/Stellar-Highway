extends StaticBody2D

static var offx:int = 2688

var Star:Resource = preload("res://GameFiles/Sprites/Currency/Star.tscn")
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
var deviation:int = 0
var d_ch:int = 0
var draSize:int
var killme:bool = true
var sin_step:float = 0.2

func _ready() -> void:
	randomize()
	mxSize = 32 + randi() % 97
	chx = 16 + randi() % 9
	if randi() % 2:
		chx = -chx
	verticality = 64 + randi() % 65
	headPump = verticality / 128.0
	timeman = randf_range(0.035, 0.05)
	sin_step = randf_range(0.1, 0.3)
	draSize = mxSize * abs(chx) + offx
	get_node("Area2D").get_node("CollisionShape2D2").shape.size.x = draSize
	if chx > 0:
		dir = 1
		get_node("DragonHead").flip_h = true
	else:
		dir = -1
		get_node("DragonHead").flip_h = false
		get_node("DragonBody").texture = preload("res://GameFiles/SpinHead IMGS/Dragon/dragonPieceFlipped.png")
		
	await get_tree().create_timer(5).timeout
	if killme:
		self.queue_free()
	
func _process(delta:float) -> void:
	cnt += delta
	if cnt >= timeman:
		cnt = 0.0
		
		draPnts = dB.points
		draPnts.push_back(Vector2(draPnts[draPnts.size()-1].x + chx, verticality*sin(x) + deviation))
		x += sin_step
		deviation += d_ch
		
		dH.position = draPnts[draPnts.size()-1] + Vector2(24 * dir, 16)
		dH.rotation = sin(x + dir*PI/4) * headPump
		
		if draPnts.size() > mxSize:
			draPnts.remove_at(0)
		else:
			draP.push_back(dP.instantiate())
			add_child(draP.back())
			draP.back().get_node("CollisionShape2D").shape = SegmentShape2D.new()
			draP.back().get_node("Area2D").get_node("CollisionShape2D2").shape = draP.back().get_node("CollisionShape2D").shape
			if draP.size() % 4 == 0:
				stTemp = Star.instantiate()
				draP.back().add_child(stTemp)
		
		dB.set_points(draPnts)
		for i in range(draP.size()):
			draP[i].get_node("CollisionShape2D").shape.b = draPnts[i]
			draP[i].get_node("CollisionShape2D").shape.a = draPnts[i+1]
			
			if draP[i].get_node_or_null("Star"):
				draP[i].get_node("Star").position = (draPnts[i] + draPnts[i+1]) / 2 + Vector2(0, -36)
		
		get_node("Area2D").position = ((draPnts[0] + draPnts[draPnts.size()-1]) / 2)

func _on_area_2d_body_exited(body:Node) -> void:
	if body.name == "Player":
		self.queue_free()

func _on_area_2d_body_entered(body:Node) -> void:
	if body.name == "Player":
		killme = false

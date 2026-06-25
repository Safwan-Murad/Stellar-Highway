extends StaticBody2D
## A rideable serpent-dragon: a long, sine-waving body you can roll along the top of.
##
## The body is a [Line2D] whose points are generated frame by frame, each new point a step
## along a sine wave; a matching [code]dragonPiece[/code] collider segment is created per point
## (with stars sprinkled on top to mark the rideable surface). Hitting the dragon from below is
## lethal; the area-exit handler frees it once you've passed. It also self-destructs after 5
## seconds if the player never engages it.

static var offx:int = 2688  ## Despawn clearance distance used by ObstacleGenerator.

var Star:Resource = preload("res://GameFiles/Sprites/Currency/Star.tscn")
var dP:Resource = preload("res://GameFiles/Sprites/Obstacles/Dragon/dragonPiece.tscn")  ## One body-segment collider.
@onready var dH:Sprite2D = get_node("DragonHead")
@onready var dB:Line2D = get_node("DragonBody")
var draPnts:PackedVector2Array = []  ## The body's points (the sine curve).
var draP:Array = []      ## The per-segment collider pieces, parallel to draPnts.
var stTemp:Node2D        ## Scratch star instance.
var x:float = 0.0        ## Phase of the sine wave (advances by sin_step each step).
var cnt:float = 0.0      ## Time accumulator so the body grows at a fixed rate.
var dir:int              ## Travel direction: +1 right, -1 left (mirrors the sprite).
var headPump:float = 0.6 ## How much the head bobs with the wave.
@export var mxSize:int = 128    ## Max number of body points (the dragon's length).
@export var timeman:float = 0.02 ## Seconds between adding body points.
@export var chx:int = -8        ## Horizontal step per body point (sign = direction).
@export var verticality:int = 64 ## Amplitude of the body's sine wave.
var deviation:int = 0    ## Slow vertical drift added to the wave (makes it weave up/down).
var d_ch:int = 0         ## Per-step change in deviation (the drift rate).
var draSize:int          ## Total body length, used to size the hitbox.
var killme:bool = true   ## If still true after 5s (player never engaged), self-destruct.
var sin_step:float = 0.2 ## Phase advance per body point (wave frequency).

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
	
## Grow the dragon one segment per tick: extend the sine body, move the head to the tip,
## recycle old points once at full length, and keep each collider piece aligned to the body.
func _process(delta:float) -> void:
	cnt += delta
	if cnt >= timeman:
		cnt = 0.0

		# Append the next body point one sine step further along.
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

## Player has rolled off the end of the dragon — despawn it.
func _on_area_2d_body_exited(body:Node) -> void:
	if body.name == "Player":
		self.queue_free()

## Player engaged the dragon — cancel the 5-second "never engaged" self-destruct.
func _on_area_2d_body_entered(body:Node) -> void:
	if body.name == "Player":
		killme = false

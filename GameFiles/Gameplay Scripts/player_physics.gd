extends CharacterBody2D

class_name PlayerPhysics

@export var ACC: float = 2.8125
@export var DEC: float = 30
@export var ROLLDEC: float = 7.5
@export var FRC: float = 2.8125
@export var SLP: float = 7.5
@export var SLPROLLUP: float = 4.6875
@export var SLPROLLDOWN: float = 18.75
@export var TOP: float = 360
@export var TOPROLL: float = 960
@export var JMP: float = 480
@export var FALL: float = 150
@export var AIR: float = 5.625
@export var GRV: float = 13.125


@onready var high_collider:CollisionShape2D = $HighCollider
@onready var low_collider:CollisionShape2D = $LowCollider

@onready var left_ground:RayCast2D = $LeftGroundSensor
@onready var right_ground:RayCast2D = $RightGroundSensor
@onready var left_wall:RayCast2D = $LeftWallSensor
@onready var right_wall:RayCast2D = $RightWallSensor

@onready var character:Node2D = $Characters
@onready var invisFrames:bool = false

var gsp : float
var ground_mode : int
var can_fall : bool
var is_ray_colliding : bool
var is_grounded : bool
var ground_point : Vector2
var ground_normal : Vector2
var is_rolling : bool
var is_wall_left : bool
var is_wall_right : bool
var vel:int
var vel_y:float
var minSpeed:int = 0
var spdOffset:int = 0
var temp:Node
var scoreStart:int = 0
var rep:int = 0
var grv_scaler:float = 1.0
@onready var star_sound_player:AudioStreamPlayer2D = get_node("StarCollect")
var currChar:int = 0
var wheel:Sprite2D
var wheel1:Sprite2D
var spinSpd:float
@onready var chars:Array[Node] = get_node("Characters").get_children()
@onready var Utils:Node2D = get_tree().get_first_node_in_group("Utils")
var trail:Line2D
var gamemode:int = 0
var ground_ray:RayCast2D
var can_jump:bool = false
var pre_speed:float = 0

func _ready() -> void:
	if name != "Player":
		currChar = 0
	add_to_group("Player")
	scoreStart = position.x
	if name == "Player":
		if Utils.loaded_data:
			if Utils.loaded_data.has("playerCharacter"):
				currChar = int(Utils.loaded_data["playerCharacter"])
		var n:int = 6
		trail = get_node("../SpeedLine")
		for i in range(n):
			if i == currChar:
				chars[i].visible = true
				if i >= 3 and i <= 5 :
					get_node("Characters").position.y = -2
				else:
					get_node("Characters").position.y = -4
				match i:
					0, 1:
						trail.position = Vector2(0, 0)
						trail.set_default_color("e76f11")
					2:
						trail.position = Vector2(-10.5, -2)
						trail.set_default_color("9b7de2")
					3:
						trail.position = Vector2(2, 0)
						trail.set_default_color("b32550")
					4:
						trail.position = Vector2(0, 4)
						trail.set_default_color("af4589")
					5:
						trail.position = Vector2(-6, 4)
						trail.set_default_color("ff84ff")
			else:
				chars[i].queue_free()
				i -= 1
				n -= 1
		if currChar == 4:
			wheel = get_node("Characters/SegwayJohnny/Wheel")
		elif currChar == 5:
			wheel = get_node("Characters/Outrider/Wheel")
			wheel1 = get_node("Characters/Outrider/Wheel1")

func _process(delta:float) -> void:
	high_collider.disabled = 1
	low_collider.disabled = 0
	left_ground.position.x = -7
	right_ground.position.x = 7
	
	if(abs(gsp) > 10) and not get_node_or_null("Lowrider"):
		spinSpd = ((5.0 / 60.0) + (gsp / 120.0))/10
		if currChar == 5:
			wheel.rotate(spinSpd)
			wheel1.rotation = wheel.rotation
		elif currChar == 4:
			wheel.rotate(spinSpd)
		elif currChar != 3:
			character.rotate(spinSpd)
	vel = int(sqrt(velocity.x*velocity.x + velocity.y*velocity.y))
	vel_y = abs(velocity.y)
	
	if get_node_or_null("../Player") and name != "Player":
		minSpeed = get_node("../Player").minSpeed
		spdOffset = get_node("../Player").spdOffset
		TOPROLL = get_node("../Player").TOPROLL
		grv_scaler = get_node("../Player").grv_scaler
		can_jump = get_node("../Player").can_jump
		if get_node("../Player").get_node_or_null("Lowrider"):
			position = get_node("../Player").position - Vector2(cos(get_node("../Player").rotation) * 40, 8 * cos(get_node("../Player").rotation) + 40 * sin(get_node("../Player").rotation))
		elif position.distance_to(get_node("../Player").position) <= 64:
			position += (position - get_node("../Player").position)/1.69
		get_tree().get_first_node_in_group("Score").extra += position.x - scoreStart
		get_tree().get_first_node_in_group("Score").extra -= rep
		rep = position.x - scoreStart
	if position.y >= 1620:
		if name != "Player":
			if get_tree().get_nodes_in_group("PowerupPopUps"):
				get_tree().get_nodes_in_group("PowerupPopUps")[3].visible = false
				get_tree().get_first_node_in_group("Player").playDoppelDead()
			self.queue_free()
		else:
			tartar_sauce(true)

func physics_step() -> void:
	position.x = max(position.x, 9.0)
	ground_ray = get_ground_ray()
	is_ray_colliding = true if ground_ray != null else false
	
	if is_on_ground():
		is_grounded = true
	
	if is_grounded and is_ray_colliding:
		ground_point = ground_ray.get_collision_point()
		ground_normal = ground_ray.get_collision_normal()
		ground_mode = int(round(rad_to_deg(ground_angle()) / 90.0)) % 4
		ground_mode = 2 if ground_mode == -2 else ground_mode
	else:
		ground_mode = 0
		ground_normal = Vector2(0, -1)
		is_grounded = false
	
	is_wall_left = left_wall.is_colliding() or position.x - 9 <= 0
	is_wall_right = right_wall.is_colliding()

func fall_from_ground():
	if abs(gsp) < FALL and ground_mode != 0:
		var angle = abs(rad_to_deg(ground_angle()))
		
		if angle >= 90 and angle <= 180:
			ground_mode = 0
			return true
		
		return false

func snap_to_ground() -> void:
	rotation_degrees = -rad_to_deg(ground_angle())
	velocity += -ground_normal * 150

func ground_reacquisition() -> void:
	var angle = abs(rad_to_deg(ground_angle()))
	if (get_node_or_null("Jetpack") || get_node_or_null("../Player/Jetpack")) and velocity.x >= minSpeed + spdOffset:
		velocity.x = max(minSpeed + spdOffset, pre_speed)
	pre_speed = 0
	
	if angle >= 0 and angle < 22.5:
		gsp = velocity.x
	elif angle >= 22.5 and angle < 45.0:
		if abs(velocity.x) > velocity.y:
			gsp = velocity.x
		else:
			gsp = velocity.y * -sign(sin(ground_angle()))
	elif angle >= 45.0 and angle < 90:
		if abs(velocity.x) > velocity.y:
			gsp = velocity.x
		else:
			gsp = velocity.y * -sign(sin(ground_angle()))
	
	rotation_degrees = -rad_to_deg(ground_angle())

func ground_angle() -> float:
	return ground_normal.angle_to(Vector2(0, -1))

func is_on_ground() -> bool:
	var ground_ray = get_ground_ray()
	
	if ground_ray != null:
		var point = ground_ray.get_collision_point()
		var normal = ground_ray.get_collision_normal()
		if abs(rad_to_deg(normal.angle_to(Vector2(0, -1)))) < 90:
			return position.y + 20 > point.y and velocity.y >= 0
	
	return false

func get_ground_ray() -> RayCast2D:
	can_fall = true
	
	if !left_ground.is_colliding() and !right_ground.is_colliding():
		return null
	elif !left_ground.is_colliding() and right_ground.is_colliding():
		return right_ground
	elif !right_ground.is_colliding() and left_ground.is_colliding():
		return left_ground
	
	can_fall = false
	
	var left_point : float
	var right_point : float
	
	match ground_mode:
		0:
			left_point = -left_ground.get_collision_point().y
			right_point = -right_ground.get_collision_point().y
		1:
			left_point = -left_ground.get_collision_point().x
			right_point = -right_ground.get_collision_point().x
		2:
			left_point = left_ground.get_collision_point().y
			right_point = right_ground.get_collision_point().y
		-1:
			left_point = left_ground.get_collision_point().x
			right_point = right_ground.get_collision_point().x
	
	if left_point >= right_point:
		return left_ground
	else:
		return right_ground

func tartar_sauce(fr:bool=false) -> void:
	if fr:
		doTheGameoverThing()
	elif not invisFrames:
		if get_node_or_null("Jetpack") or get_node_or_null("Umbrella") or get_node_or_null("Lowrider"):
			invisFrames = true
			TOPROLL -= 3 * spdOffset
			spdOffset = 0
			grv_scaler = 1
			can_jump = false
			temp = get_node_or_null("Jetpack")
			if temp:
				get_tree().get_nodes_in_group("PowerupPopUps")[0].text = ""
				get_tree().get_nodes_in_group("PowerupPopUps")[2].visible = false
				temp.queue_free()
			temp = get_node_or_null("Umbrella")
			if temp:
				get_tree().get_nodes_in_group("PowerupPopUps")[0].text = ""
				get_tree().get_nodes_in_group("PowerupPopUps")[4].visible = false
				temp.queue_free()
			temp = get_node_or_null("Lowrider")
			if temp:
				get_tree().get_first_node_in_group("MoreBounce").visible = false
				get_tree().get_nodes_in_group("PowerupPopUps")[0].text = ""
				get_tree().get_nodes_in_group("PowerupPopUps")[5].visible = false
				temp.queue_free()
			get_node("Characters").get_node("AnimationPlayer").play("invisFrames")
			await get_tree().create_timer(4).timeout
			invisFrames = false
			get_node("Characters").get_node("AnimationPlayer").play("Reset")
		else:
			doTheGameoverThing()

func doTheGameoverThing() -> void:
	Utils.savegame(currChar, get_tree().get_first_node_in_group("StarCnt").stars)
	get_tree().get_first_node_in_group("pauseman").switchJobs()
	get_tree().paused = true
	var finalScore:int = get_tree().get_first_node_in_group("Score").sc
	finalScore += get_tree().get_first_node_in_group("Score").of
	Utils.saveScore(finalScore, gamemode)
	get_tree().get_first_node_in_group("clipperBoy").myCondolences()

func playStarSound() -> void:
	star_sound_player.play()

func playDoppelDead() -> void:
	get_node("DoppelDead").play()

extends CharacterBody2D

class_name PlayerPhysics
## The playable character: Sonic-style momentum physics plus all game concerns.
##
## Adapted from marmitoTH's Godot Sonic Physics. The character is always rolling;
## it follows terrain (player-drawn lines and building rooftops) using four
## raycast "sensors", carries its momentum as a ground speed [member gsp], and
## speeds up downhill / slows down uphill. The actual per-frame movement is driven
## by [code]state_machine.gd[/code] and its [code]OnGround[/code]/[code]OnAir[/code]
## states; this script holds the shared state those states read and write.
##
## On top of the base physics it also handles everything game-specific: rendering
## the selected character, the speed trail, star-collect sound, syncing the
## Doppelgänger clone, powerup bookkeeping, and the damage / game-over flow
## ([method tartar_sauce] → [method doTheGameoverThing]).
##
## The same script powers both the real player (node named "Player") and the
## Doppelgänger clone (node named "PlayerSUS"); most branches key off [code]name[/code].

# --- Physics tuning constants (Sonic Physics Guide values, in this game's scale) ---
@export var ACC: float = 2.8125       ## Ground acceleration.
@export var DEC: float = 30           ## Deceleration when braking.
@export var ROLLDEC: float = 7.5      ## Deceleration while rolling.
@export var FRC: float = 2.8125       ## Ground friction.
@export var SLP: float = 7.5          ## Slope factor while running.
@export var SLPROLLUP: float = 4.6875 ## Slope factor while rolling uphill.
@export var SLPROLLDOWN: float = 18.75 ## Slope factor while rolling downhill.
@export var TOP: float = 360          ## Top horizontal speed while running.
@export var TOPROLL: float = 960      ## Top rolling speed; raised over time by spdManager and by powerups.
@export var JMP: float = 480          ## Jump impulse (only usable with the Lowrider powerup).
@export var FALL: float = 150         ## Speed below which the character falls off walls/ceilings.
@export var AIR: float = 5.625        ## Air acceleration.
@export var GRV: float = 13.125       ## Gravity applied per physics frame (scaled by grv_scaler).


# Two hitboxes: a tall "standing" one and a short "rolling" one. The character is
# always rolling here, so low_collider is the one kept active (see _process).
@onready var high_collider:CollisionShape2D = $HighCollider
@onready var low_collider:CollisionShape2D = $LowCollider

# The four terrain "sensors". Ground sensors find the floor and its slope; wall
# sensors detect head-on walls (which stop ground speed and can game-over you).
@onready var left_ground:RayCast2D = $LeftGroundSensor
@onready var right_ground:RayCast2D = $RightGroundSensor
@onready var left_wall:RayCast2D = $LeftWallSensor
@onready var right_wall:RayCast2D = $RightWallSensor

@onready var character:Node2D = $Characters  ## Holds the visual sprites of every character.
@onready var invisFrames:bool = false        ## True during post-hit invincibility (see tartar_sauce).

var gsp : float                ## Ground speed: signed speed along the current slope. The heart of the physics.
var ground_mode : int          ## Which quadrant the ground faces: 0 floor, 1/-1 walls, 2 ceiling.
var can_fall : bool            ## True when only one ground sensor is grounded (an edge), so the body may fall.
var is_ray_colliding : bool    ## True when a usable ground ray was found this step.
var is_grounded : bool         ## True when standing on ground (drives OnGround/OnAir transitions).
var ground_point : Vector2     ## World point under the body where the ground was sensed.
var ground_normal : Vector2    ## Surface normal of the sensed ground (defines the slope).
var is_rolling : bool          ## True while rolling (always true on the ground in this game).
var is_wall_left : bool        ## True when a wall is touching the left side.
var is_wall_right : bool       ## True when a wall is touching the right side.
var vel:int                    ## Cached speed magnitude (shown on the HUD).
var vel_y:float                ## Cached vertical speed magnitude.
var minSpeed:int = 0           ## Auto-run floor speed; ramped up over distance by spdManager. 0 = not started.
var spdOffset:int = 0          ## Extra speed granted by the Jetpack powerup.
var temp:Node                  ## Scratch reference reused across powerup cleanup.
var scoreStart:int = 0         ## The body's starting X, used to measure how far a clone has travelled.
var rep:int = 0                ## Last frame's clone progress, to avoid double-counting it into the score.
var grv_scaler:float = 1.0     ## Gravity multiplier; the Umbrella powerup sets this below 1 for a slow fall.
@onready var star_sound_player:AudioStreamPlayer2D = get_node("StarCollect")
var currChar:int = 0           ## Index (0-5) of the selected character.
var wheel:Sprite2D             ## Spinning wheel sprite for wheeled characters (Segway/Outrider).
var wheel1:Sprite2D            ## Second wheel for the Outrider.
var spinSpd:float              ## Per-frame rotation applied to the rolling sprite/wheel.
@onready var chars:Array[Node] = get_node("Characters").get_children()
@onready var Utils:Node2D = get_tree().get_first_node_in_group("Utils")
var trail:Line2D               ## The speed-line trail behind the player.
var gamemode:int = 0           ## 0 Endless, 1 Hole-in-a-Wall, 2 Missiles (set by the mode's OST script).
var ground_ray:RayCast2D       ## The ground sensor chosen as authoritative this step.
var can_jump:bool = false      ## Whether jumping is allowed (enabled by the Lowrider powerup).
var pre_speed:float = 0        ## Ground speed remembered at takeoff, restored on landing for the Jetpack.

## Joins the "Player" group and, for the real player, loads the saved character,
## shows only that character's sprite (freeing the rest), and positions its trail.
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

## Per-frame visuals and bookkeeping (not the physics — that's in _physics_process
## via the state machine). Spins the rolling sprite, caches the speed readouts,
## mirrors the real player's state onto the Doppelgänger clone, and triggers a
## game over / clone cleanup when a body falls off the bottom of the screen.
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
	
	# Doppelgänger clone: copy the real player's speed/state, trail it, and feed the
	# distance it covers into the score as bonus "extra" (rep prevents double counting).
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
	# Fell off the bottom of the screen: a clone just despawns; the real player dies.
	if position.y >= Refs.KILL_Y:
		if name != "Player":
			if get_tree().get_nodes_in_group("PowerupPopUps"):
				get_tree().get_nodes_in_group("PowerupPopUps")[3].visible = false
				get_tree().get_first_node_in_group("Player").playDoppelDead()
			self.queue_free()
		else:
			tartar_sauce(true)

## Updates the sensors every physics frame (called by the state machine before the
## active state runs). Resolves which ground ray is authoritative, derives the
## ground mode/normal/point, and flags wall contacts.
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

## Returns true if the character is too slow to cling to a steep wall/ceiling and
## should drop back into the air state (Sonic's "fall off when slow" rule).
func fall_from_ground():
	if abs(gsp) < FALL and ground_mode != 0:
		var angle = abs(rad_to_deg(ground_angle()))
		
		if angle >= 90 and angle <= 180:
			ground_mode = 0
			return true
		
		return false

## Keeps the character glued to the surface across a slope: aligns rotation to the
## ground and nudges velocity into the surface so it doesn't pop off small bumps.
func snap_to_ground() -> void:
	rotation_degrees = -rad_to_deg(ground_angle())
	velocity += -ground_normal * 150

## Converts the airborne velocity back into ground speed [member gsp] on landing,
## choosing how to project velocity based on how steep the landing slope is.
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

## The slope angle (radians) of the current ground, measured from straight up.
func ground_angle() -> float:
	return ground_normal.angle_to(Vector2(0, -1))

## Whether the body is currently resting on a floor-ish surface (used to (re)enter
## the grounded state): a ground ray exists, faces upward enough, and we're falling onto it.
func is_on_ground() -> bool:
	var ground_ray = get_ground_ray()
	
	if ground_ray != null:
		var point = ground_ray.get_collision_point()
		var normal = ground_ray.get_collision_normal()
		if abs(rad_to_deg(normal.angle_to(Vector2(0, -1)))) < 90:
			return position.y + 20 > point.y and velocity.y >= 0
	
	return false

## Picks which ground sensor to trust. If only one sensor hits, the body is on an
## edge and [member can_fall] is set; if both hit, the higher contact (relative to
## the current ground mode) wins so the body hugs the surface.
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

## The "took a hit" handler. [param fr] forces an immediate game over (used when the
## body falls off-screen). Otherwise, if a defensive powerup (Jetpack/Umbrella/
## Lowrider) is held, it is consumed for ~4 seconds of invincibility; if not, the
## run ends. ("tartar_sauce" is just a playful name for getting wrecked.)
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

## Commits the game over: persists stars and the final score, pauses the scene
## tree, and shows the clapperboard game-over screen.
func doTheGameoverThing() -> void:
	Settings.vibrate(120)
	Refs.shake(1.0)
	Utils.savegame(currChar, get_tree().get_first_node_in_group("StarCnt").stars)
	get_tree().get_first_node_in_group("pauseman").switchJobs()
	get_tree().paused = true
	var finalScore:int = get_tree().get_first_node_in_group("Score").sc
	finalScore += get_tree().get_first_node_in_group("Score").of
	Utils.saveScore(finalScore, gamemode)
	get_tree().get_first_node_in_group("clipperBoy").myCondolences()

## Plays the star-pickup chime (called by stars when collected).
func playStarSound() -> void:
	star_sound_player.play()

## Plays the sound for the Doppelgänger clone dying.
func playDoppelDead() -> void:
	get_node("DoppelDead").play()

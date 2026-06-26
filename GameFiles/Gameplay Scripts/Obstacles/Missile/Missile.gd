extends CharacterBody2D
## A homing missile that chases the player and explodes on impact.
##
## This one script powers BOTH missile types, told apart by whether a "Fire" node exists:
## [br]• with "Fire" (a lit jet) → a lock-on Missile: groups GMissiles + Missiles, detonates
##   on hitting any surface ([method gg]). You can steer it into a drawn line to kill it.
## [br]• without "Fire" → a TimedMissile: groups GMissiles + TMissiles, can't be detonated by
##   surfaces; its fuse (Fuse4Missile.gd) calls [method gg1] after a few seconds.
## Each frame it eases its velocity toward the player and points itself at them.

static var offx:int = 0  ## Despawn clearance (0 — missiles clean themselves up on explosion).

@onready var player:CharacterBody2D = get_node("../Player")
var playerPos:Vector2  ## The player's position this frame (the homing target).
var playerVel:Vector2  ## The player's velocity this frame (used to lead the target slightly).
var timeman:float = 0.0  ## Throttle so the homing velocity is recomputed only every 0.1s.
@onready var anim:AnimatedSprite2D = get_node_or_null("Fire")  ## Present only on lock-on missiles.
var pleaseStopHesAlreadyDead:bool = false  ## True once exploded, so further hits are ignored.

func _ready() -> void:
	add_to_group("GMissiles")
	if anim:
		add_to_group("Missiles")
		randomize()
		if randi()%2 == 1:
			anim.play("fire_R")
		else:
			anim.play("fire_B")
	else:
		add_to_group("TMissiles")

## Home in on the player and face the direction of travel. The velocity update (every 0.1s)
## blends three terms: keep 85% of current velocity (momentum/turn smoothing), steer toward the
## player at the player's own min speed, and add a small lead based on the player's velocity — so
## the missile curves after you rather than snapping straight at you.
func _physics_process(delta) -> void:
	timeman += delta
	playerPos = player.position
	playerVel = player.velocity
	if timeman > 0.1 and not pleaseStopHesAlreadyDead:
		timeman = 0.0
		playerPos = player.position
		velocity = 0.85 * velocity + 0.15 * player.minSpeed * (playerPos - position).normalized() + 0.07 * (playerPos - position + playerVel)
	rotation = (playerPos - position).angle()
	move_and_slide()

## A lock-on missile hit something: explode (unless it was another missile). The "sus" check
## lets it pass harmlessly through collected/inactive stars.
func _on_kill_me_body_entered(body:Node) -> void:
	if body.name != "Missile" or body.name != "TimedMissile":
		if "sus" in body:
			if body.sus:
				gg()
		else:
			gg()

## Explode a lock-on missile: stop it, leave its groups, and play the blast. ("gg" = it's over.)
func gg() -> void:
	get_node("ExpSound").play()
	Refs.shake(0.35)
	pleaseStopHesAlreadyDead = true
	velocity = Vector2(0, 0)
	remove_from_group("GMissiles")
	remove_from_group("Missiles")
	get_node("killArea").queue_free()
	get_node("killMe").queue_free()
	get_node("Fire").queue_free()
	get_node("Misslie").queue_free()
	get_node("Explosion").visible = true
	get_node("Explosion").play("newExp")

## Explode a timed missile (called by its fuse when it burns out).
func gg1() -> void:
	get_node("ExpSound").play()
	Refs.shake(0.5)
	pleaseStopHesAlreadyDead = true
	velocity = Vector2(0, 0)
	remove_from_group("GMissiles")
	remove_from_group("TMissiles")
	get_node("killArea").queue_free()
	get_node("TimedMisslie").queue_free()
	get_node("Explosion").visible = true
	get_node("Explosion").play("newExp")

func _on_exp_sound_finished() -> void:
	self.queue_free()

func _on_explosion_animation_finished() -> void:
	get_node("Explosion").queue_free()

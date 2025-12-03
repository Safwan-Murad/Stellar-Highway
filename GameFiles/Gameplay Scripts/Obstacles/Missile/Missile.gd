extends CharacterBody2D

static var offx:int = 0

@onready var player:CharacterBody2D = get_node("../Player")
var playerPos:Vector2
var playerVel:Vector2
var timeman:float = 0.0
@onready var anim:AnimatedSprite2D = get_node_or_null("Fire")
var pleaseStopHesAlreadyDead:bool = false

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

func _on_kill_me_body_entered(body:Node) -> void:
	if body.name != "Missile" or body.name != "TimedMissile":
		if "sus" in body:
			if body.sus:
				gg()
		else:
			gg()

func gg() -> void:
	get_node("ExpSound").play()
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

func gg1() -> void:
	get_node("ExpSound").play()
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

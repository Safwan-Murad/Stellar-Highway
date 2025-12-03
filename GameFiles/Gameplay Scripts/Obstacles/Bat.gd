extends AnimatedSprite2D

var truePos
var playerPos
var playerVel
var velocity = Vector2(0, 0)
var near = false
var difficulty = 0.015

func _ready():
	play("Idle")
	flip_v = true
	

func _process(_delta):
	truePos = position + get_parent().position
	playerPos = get_tree().get_first_node_in_group("Player").position
	playerVel = get_tree().get_first_node_in_group("Player").velocity
	
	if (abs(playerPos.x - truePos.x) + abs(playerPos.y - truePos.y) <= 960) and not near:
		near = true
		flip_v = false
		play("Fly")
		velocity = (playerPos - truePos)
		velocity.x += playerVel.x
		velocity.y += 0.3 * playerVel.y
		if velocity.x > 0:
			flip_h = false
		elif velocity.x < 0:
			flip_h = true
	elif (abs(playerPos.x - truePos.x) + abs(playerPos.y - truePos.y) >= 1500) and near:
		self.queue_free()
		
	position += velocity * difficulty

extends AnimatedSprite2D
## A single bat that sleeps until the player gets close, then swoops at them.
##
## While idle it hangs upside-down. When the player comes within range it wakes, aims a swoop
## velocity that leads the player's movement, and flies off; once far past, it frees itself.
## [member difficulty] scales how fast it homes.

var truePos     ## This bat's world position (own position + parent offset).
var playerPos   ## The player's position this frame.
var playerVel   ## The player's velocity this frame (used to lead the swoop).
var velocity = Vector2(0, 0)  ## The swoop velocity once awoken.
var near = false              ## True once the bat has woken and started its swoop.
var difficulty = 0.015        ## Homing strength multiplier.

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

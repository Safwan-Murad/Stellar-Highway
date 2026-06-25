extends CharacterBody2D
## Speed-boost pad: a one-shot bounce that flings the player forward.
##
## Unlike the other powerups this isn't held — touching its detector adds a burst of speed to
## the player, then the pad itself is launched off with a random [member throw] and falls away
## under gravity (cleaned up once off-screen).

var letsBounce:bool = false  ## True after it's been hit, so it starts falling under gravity.
var throw:Vector2            ## The random launch velocity given to the pad when triggered.

var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	randomize()
	throw = Vector2(randf_range(256, 1024), randf_range(-256, -1024))
	if randi() % 2:
		throw.x *= -1

func _process(_delta:float) -> void:
	if position.y > 2024:
		self.queue_free()

func _physics_process(delta:float) -> void:
	if letsBounce:
		velocity.y += gravity * delta
	
	move_and_slide()

## On the player hitting the pad, add a speed burst (ground speed or air velocity) and fling
## the pad away.
func _on_detector_body_entered(body:Node) -> void:
	if body.name == "Player":
		get_node("Detector").queue_free()
		if body.is_grounded:
			body.gsp += 400
		else:
			body.velocity.x += 400
		get_node("BoosterPost").play("spin")
		get_node("BoosterSound").play()
		velocity += throw
		reparent(get_node("../../"))
		
		letsBounce = true

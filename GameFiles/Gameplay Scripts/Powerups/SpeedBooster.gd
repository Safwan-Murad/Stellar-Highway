extends CharacterBody2D

var letsBounce:bool = false
var throw:Vector2

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

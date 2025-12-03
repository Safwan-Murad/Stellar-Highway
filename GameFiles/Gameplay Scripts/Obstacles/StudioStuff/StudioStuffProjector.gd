extends CharacterBody2D

@onready var player:CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var posOff:Vector2 = get_node("../").position
var dontTroll:int = 0
var fall:bool = false
var mg:float = 88.2
var smokeEmRange:int = 220

func _ready() -> void:
	randomize()
	dontTroll = randi() % 3
	smokeEmRange += randi() % 569

func _physics_process(_delta:float) -> void:
	if not dontTroll:
		look_at(player.position)
		rotation -= PI/2
	
	if abs(player.global_position.x - global_position.x) <= smokeEmRange and not dontTroll:
		fall = true
	
	if fall:
		velocity.y += mg
		move_and_slide()

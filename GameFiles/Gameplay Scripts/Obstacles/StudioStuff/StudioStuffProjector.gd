extends CharacterBody2D
## A single studio light that watches the player and drops on them when they get close.
##
## Roughly one in three is a harmless dud ([member dontTroll]); the rest rotate to "look at"
## the player and, once the player is within [member smokeEmRange] horizontally, fall straight
## down. You can bait a light into falling early, or just outrun it. Touching it is lethal.

@onready var player:CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var posOff:Vector2 = get_node("../").position
var dontTroll:int = 0      ## 0 = a live (dangerous) light; nonzero = a harmless dud that won't fall.
var fall:bool = false      ## True once it has been triggered and is dropping.
var mg:float = 88.2        ## Gravity added per physics frame while falling.
var smokeEmRange:int = 220 ## Horizontal trigger distance (randomised per light).

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

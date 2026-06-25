extends Node2D
## Menu flavour: periodically drops a player-clone that rolls down across the menu.
##
## Every couple of seconds it spawns a [code]PlayerSUS[/code] body at a random spot up top
## and lets the physics carry it down the screen — purely decorative motion behind the menu.

var imposter:Resource = preload("res://GameFiles/Sprites/PlayerSUS.tscn")
var timeman:float = 0.0       ## Time accumulator between spawns.
var da_sus:CharacterBody2D    ## The most recently spawned clone.

func _ready() -> void:
	randomize()

func _process(delta:float) -> void:
	timeman += delta
	if timeman > 2:
		timeman = 0
		da_sus = imposter.instantiate()
		da_sus.position = Vector2(randi() % 1921, -64)
		da_sus.minSpeed = 600
		da_sus.TOPROLL = 1800
		get_parent().add_child(da_sus)

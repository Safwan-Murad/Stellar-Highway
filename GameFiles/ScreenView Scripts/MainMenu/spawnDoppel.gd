extends Node2D

var imposter:Resource = preload("res://GameFiles/Sprites/PlayerSUS.tscn")
var timeman:float = 0.0
var da_sus:CharacterBody2D

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

extends Node2D

@export var anim : String = "Rotate"
@export var path : String = "AnimationPlayer"

func _ready() -> void:
	get_node(path).play(anim)

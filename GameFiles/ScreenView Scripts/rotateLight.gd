extends Node2D
## Tiny helper that just starts a looping animation on ready (e.g. a rotating spotlight).
##
## Both the animation name and the AnimationPlayer path are exported so the same script can
## be reused on any decorative node that should auto-play one animation.

@export var anim : String = "Rotate"            ## Animation to play.
@export var path : String = "AnimationPlayer"   ## Node path to the AnimationPlayer.

func _ready() -> void:
	get_node(path).play(anim)

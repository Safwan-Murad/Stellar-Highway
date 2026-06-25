extends Node2D
## A cluster of hanging studio lights (the "Studio Lights" hazard).
##
## This is just the container: it randomly scales the whole rig a little for variety and sets
## its despawn clearance accordingly. The actual drop-on-you behaviour lives on each child light
## (see StudioStuffProjector.gd).

var offx:int = 1229  ## Despawn clearance distance (scales with RNG).
var RNG:float        ## Random size multiplier applied to the whole rig.

func _ready() -> void:
	randomize()
	RNG = randf_range(1, 1.1)
	scale = Vector2(RNG, RNG)
	offx = 1024 * RNG

extends StaticBody2D
## A wrecking-ball pendulum that swings under simple gravity-driven pendulum physics.
##
## Each tick it accelerates toward the bottom (acceleration ∝ -sin(angle)) and integrates that
## into its swing, so it rocks back and forth forever. [member ThetaMax] sets the swing strength
## (UnderConstruction.gd randomises it per pendulum).

@onready var ThetaMax:float = 0.003  ## Pendulum strength (max angular acceleration).
var acc:float          ## Angular acceleration this tick.
var vel:float = 0.0    ## Current angular velocity.
var cnt:float = 0.0    ## Time accumulator for the fixed-step integration.

func _physics_process(delta:float) -> void:
	cnt += delta
	if cnt > 0.02:
		cnt = 0.0
		acc = -ThetaMax*sin(rotation)
		vel += acc
		rotation += vel

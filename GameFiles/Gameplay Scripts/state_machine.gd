extends Node
## Drives the player's physics each frame through a two-state machine.
##
## The host is the parent [code]PlayerPhysics[/code] body. Every physics frame this
## refreshes the host's sensors, runs the active state (OnGround / OnAir), applies
## any requested transition, and then moves the body. The state scripts live as
## child nodes of this one (see [code]States/[/code]).

## The available states, keyed by name. Each is a child node extending state.gd.
@onready var states:Dictionary = {
	'OnGround' : $OnGround,
	'OnAir' : $OnAir,
}

@onready var host:CharacterBody2D = get_parent()  ## The PlayerPhysics body this machine controls.

var current_state:String = 'OnGround'
var previous_state = null

func _physics_process(delta:float) -> void:
	host.physics_step()

	# Run the active state; if it returns a state name, switch to it.
	var state_name = states[current_state].step(host, delta)

	if state_name:
		change_state(state_name)

	host.set_velocity(host.velocity)
	host.move_and_slide()
	host.velocity = host.velocity

## Switches to [param state_name], firing the old state's exit() and the new one's enter().
func change_state(state_name:String) -> void:
	if state_name == current_state:
		return
	
	states[current_state].exit(host)
	previous_state = current_state
	current_state = state_name
	states[current_state].enter(host)

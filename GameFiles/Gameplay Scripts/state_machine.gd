extends Node

@onready var states:Dictionary = {
	'OnGround' : $OnGround,
	'OnAir' : $OnAir,
}

@onready var host:CharacterBody2D = get_parent()

var current_state:String = 'OnGround'
var previous_state = null

func _physics_process(delta:float) -> void:
	host.physics_step()
	
	var state_name = states[current_state].step(host, delta)
	
	if state_name:
		change_state(state_name)
	
	host.set_velocity(host.velocity)
	host.move_and_slide()
	host.velocity = host.velocity

func change_state(state_name:String) -> void:
	if state_name == current_state:
		return
	
	states[current_state].exit(host)
	previous_state = current_state
	current_state = state_name
	states[current_state].enter(host)

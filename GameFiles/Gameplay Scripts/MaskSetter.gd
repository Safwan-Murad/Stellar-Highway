extends Area2D
## Switches which physics layer the player collides with as it crosses this zone.
##
## The world uses two collision layers (1 and 2) so the character can pass through one
## set of surfaces while still landing on another (used for the Hotel's one-way halls and
## similar setups). When the player enters, this enables one layer and disables the other
## on the body and its ground sensors. [member SWITCH_MODE] chooses the direction:
## LEFT_TO_RIGHT, RIGHT_TO_LEFT, or INVERT (swap whichever is currently active).

enum Switch { LEFT_TO_RIGHT, RIGHT_TO_LEFT, INVERT }
@export var SWITCH_MODE: Switch = Switch.LEFT_TO_RIGHT

var check_mask : int    ## The collision layer to turn ON.
var uncheck_mask : int  ## The collision layer to turn OFF.

## Activate layer 2, deactivate layer 1.
func left_to_right():
	check_mask = 2
	uncheck_mask = 1

## Activate layer 1, deactivate layer 2.
func right_to_left():
	check_mask = 1
	uncheck_mask = 2

## Swap whichever layer is currently active for the other.
func invert(is_left_activated, is_right_activated):
	if is_left_activated :
		check_mask = 2
		uncheck_mask = 1
	elif is_right_activated :
		check_mask = 1
		uncheck_mask = 2

## On the player entering, apply the chosen switch to the body and its ground sensors.
func _on_Area2D_body_entered(body):
	if body.name == 'Player':
		var left = body.get_collision_mask_value(1)
		var right = body.get_collision_mask_value(2)
		
		match SWITCH_MODE:
			Switch.LEFT_TO_RIGHT:
				left_to_right()
			Switch.RIGHT_TO_LEFT:
				right_to_left()
			Switch.INVERT:
				invert(left, right)
		
		body.set_collision_mask_value(check_mask, true)
		body.set_collision_mask_value(uncheck_mask, false)
		body.left_ground.set_collision_mask_value(check_mask, true)
		body.left_ground.set_collision_mask_value(uncheck_mask, false)
		body.right_ground.set_collision_mask_value(check_mask, true)
		body.right_ground.set_collision_mask_value(uncheck_mask, false)

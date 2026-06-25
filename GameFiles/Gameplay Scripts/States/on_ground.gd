extends '../state.gd'
## Player state: rolling along the ground.
##
## Applies slope acceleration (uphill slows, downhill speeds up), friction, the
## auto-run minimum speed, the rolling speed cap, wall stops, and jumping. Drops to
## OnAir when there's no ground or the body is too slow to hold a steep surface.

var slope : float  ## The slope factor used this frame (uphill vs downhill differ).

func step(host:CharacterBody2D, _delta:float):

	# No ground under us (or too slow to cling to a wall/ceiling) -> become airborne.
	if !host.is_ray_colliding or host.fall_from_ground():
		host.is_grounded = false
		host.pre_speed = host.gsp
		return 'OnAir'

	host.is_rolling = true

	# Slope acceleration: weaker climbing, stronger descending (Sonic rolling rule).
	if sign(host.gsp) == sign(sin(host.ground_angle())):
		slope = host.SLPROLLUP
	else:
		slope = host.SLPROLLDOWN
	
	host.gsp -= slope * sin(host.ground_angle())
	host.gsp -= min(abs(host.gsp), host.FRC / 2.0) * sign(host.gsp)
	host.gsp = clamp(host.gsp, -host.TOPROLL, host.TOPROLL)
	# Auto-run: gently push the speed back up toward the minimum so the character
	# never fully stops (unless climbing too steep a wall, where cos() guards it).
	if host.gsp <= host.minSpeed + host.spdOffset:
		if host.grv_scaler < 1 and host.velocity.x >= -40 and cos(host.ground_angle()) >= 0.1:
			host.gsp += host.minSpeed/20
		elif cos(host.ground_angle()) >= 0.5 and host.velocity.x >= -40:
			host.gsp += host.minSpeed/20
	host.gsp = .0 if host.is_wall_left and host.gsp < 0 else host.gsp
	host.gsp = .0 if host.is_wall_right and host.gsp > 0 else host.gsp
	host.velocity.x = host.gsp * cos(host.ground_angle())
	host.velocity.y = host.gsp * -sin(host.ground_angle())
	
	# Jump (only enabled by the Lowrider powerup): launch along the ground normal.
	if host.can_jump and Input.is_action_just_pressed("ui_accept"):
		if host.get_node_or_null("Lowrider"):
			host.get_node("Lowrider/Lowrider").play("bounce")
			host.get_node("Lowrider/LowriderJUMP").play()
		host.velocity.x -= host.JMP * sin(host.ground_angle())
		host.velocity.y -= host.JMP * cos(host.ground_angle())
		host.rotation_degrees = 0
		host.pre_speed = host.gsp
		host.is_grounded = false
		return 'OnAir'
	
	if !host.can_fall:
		host.snap_to_ground()

func exit(_host:CharacterBody2D) -> void:
	pass

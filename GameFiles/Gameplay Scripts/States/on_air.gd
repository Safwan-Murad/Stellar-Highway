extends '../state.gd'

var has_rolled : bool

func enter(host:CharacterBody2D) -> void:
	has_rolled = host.is_rolling
	host.is_rolling = false

func step(host:CharacterBody2D, _delta:float):
	if host.is_grounded:
		host.ground_reacquisition()
		return 'OnGround'
	
	var no_rotation = has_rolled
	host.rotation_degrees = int(lerp(host.rotation_degrees, 0.0, .2)) if !no_rotation else 0
	
	if host.velocity.y < 0 and host.velocity.y > -240:
		host.velocity.x -= int(host.velocity.x / 7.5) / 15360.0
	elif host.get_node_or_null("Lowrider") && host.velocity.y >= 0:
		if host.get_node("Lowrider/Lowrider").frame != 0:
			host.get_node("Lowrider/Lowrider").play_backwards("bounce")
	
	host.velocity.y += host.GRV * host.grv_scaler
	
	if host.get_node_or_null("Jetpack") || host.get_node_or_null("../Player/Jetpack"):
		host.velocity.x += 5
	
	host.velocity.x = 0 if host.is_wall_left and host.velocity.x < 0 else host.velocity.x
	host.velocity.x = 0 if host.is_wall_right and host.velocity.x > 0 else host.velocity.x

func exit(_host:CharacterBody2D) -> void:
	pass

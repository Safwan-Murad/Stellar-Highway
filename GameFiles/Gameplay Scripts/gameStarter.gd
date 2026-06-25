extends Label
## The "tap to begin" prompt that kicks off a run on the first touch.
##
## Until the player touches the screen the run is idle. On the first touch this sets the
## player's starting auto-run speed (faster in Missiles mode), starts the relevant spawner
## (MissileManager waves, or arming WallGenManager), then removes itself.

func _input(event:InputEvent) -> void:
	if event is InputEventScreenTouch:
		if get_node_or_null("../../../sizeChange/MissileManager"):
			get_tree().get_first_node_in_group("Player").minSpeed = 600
			get_tree().get_first_node_in_group("Player").TOPROLL = 3 * 600
			get_node("../../../sizeChange/MissileManager").start()
		else:
			get_tree().get_first_node_in_group("Player").minSpeed = 400
			get_tree().get_first_node_in_group("Player").TOPROLL = 3 * 400
			if get_node_or_null("../../../sizeChange/WallGenManager"):
				get_node("../../../sizeChange/WallGenManager").gameStart = true
		self.queue_free()

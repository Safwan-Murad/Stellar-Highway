extends Label

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

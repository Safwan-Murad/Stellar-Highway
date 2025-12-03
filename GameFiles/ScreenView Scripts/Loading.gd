extends AnimatedSprite2D

func _ready() -> void:
	visible = false

func loadStart(scene:String) -> void:
	scale.x = 2.5 * get_node("../../../sizeChange").true_scalex/get_node("../../../sizeChange").true_scaley
	frame = 0
	speed_scale = 1
	visible = true
	play("load")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file(scene)
	
func loadEnd() -> void:
	await get_tree().create_timer(0.034).timeout
	scale.x = 2.5 * get_node("../../../sizeChange").true_scalex/get_node("../../../sizeChange").true_scaley
	visible = true
	frame = 30
	speed_scale = -1
	play("load")
	await get_tree().create_timer(1).timeout
	self.queue_free()

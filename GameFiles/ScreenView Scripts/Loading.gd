extends AnimatedSprite2D
## The load-in / load-out transition animation between scenes.
##
## [method loadStart] plays the animation forward and then changes to a new scene (used
## when leaving the menu). [method loadEnd] plays it backward to reveal a freshly loaded
## scene, then frees itself. Scaled to the current aspect ratio so it covers the screen.

func _ready() -> void:
	visible = false

## Cover the screen with the loading animation, then switch to [param scene].
func loadStart(scene:String) -> void:
	scale.x = 2.5 * get_node("../../../sizeChange").true_scalex/get_node("../../../sizeChange").true_scaley
	frame = 0
	speed_scale = 1
	visible = true
	play("load")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file(scene)
	
## Play the loading animation in reverse to uncover the new scene, then free this node.
func loadEnd() -> void:
	await get_tree().create_timer(0.034).timeout
	scale.x = 2.5 * get_node("../../../sizeChange").true_scalex/get_node("../../../sizeChange").true_scaley
	visible = true
	frame = 30
	speed_scale = -1
	play("load")
	await get_tree().create_timer(1).timeout
	self.queue_free()

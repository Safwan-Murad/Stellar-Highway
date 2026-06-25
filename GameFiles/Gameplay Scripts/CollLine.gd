extends StaticBody2D
## One segment of player-drawn terrain (instanced by playerInput.gd).
##
## A short solid line the character can roll on. It deletes itself either after a few
## seconds or once the player has rolled past it, so drawn lines don't pile up in memory.

var disTime:float = 3.0  ## Seconds left before this segment auto-deletes.
var sus:bool = true      ## Guard so the fade-out is only triggered once.

func _process(delta:float):
	disTime-=delta

	# Time's up: fade out and free.
	if disTime <= 0 and is_instance_valid(self) and sus:
		sus = false
		killMe4FreeRAM()

## Fade out early once the player has rolled off this segment.
func _on_area_2d_body_exited(body):
	if body.name == "Player" and is_instance_valid(self) and sus:
		sus = false
		killMe4FreeRAM()

## Tween the segment to transparent, then free it (reclaiming memory).
func killMe4FreeRAM():
	var tween:Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.3)
	tween.tween_callback(queue_free)

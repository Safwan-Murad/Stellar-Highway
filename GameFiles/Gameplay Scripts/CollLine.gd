extends StaticBody2D
## One segment of player-drawn terrain (instanced by playerInput.gd).
##
## A short solid line the character can roll on. It deletes itself either after a few
## seconds or once the player has rolled past it, so drawn lines don't pile up in memory.

var disTime:float = 3.0  ## Seconds left before this segment auto-deletes.
var sus:bool = true      ## Guard so the fade-out is only triggered once.

func _ready() -> void:
	# The scene wires up body_exited (for the fade); we also light the segment up on enter.
	get_node("Area2D").body_entered.connect(_on_area_2d_body_entered)

## Light up while the player is rolling onto this segment — it brightens and swells, then the
## body_exited fade dissolves it behind the player. Purely cosmetic.
func _on_area_2d_body_entered(body:Node) -> void:
	if body.name == "Player":
		var ln:Line2D = get_node("Line2D")
		ln.default_color = ln.default_color.lerp(Color.WHITE, 0.75)
		var tween:Tween = create_tween()
		tween.tween_property(ln, "width", ln.width * 1.8, 0.08)

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

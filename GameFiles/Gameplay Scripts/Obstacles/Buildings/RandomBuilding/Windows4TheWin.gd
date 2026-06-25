extends Polygon2D
## The face of a procedural building — tiles windows across its interior on demand.
##
## This is the [Polygon2D] body of a RandomBuilding; the generator calls [method decorationTime]
## once the building's bounds are known to grid-fill it with [code]BuildingWindow[/code] sprites.

var B_Window:Resource = preload("res://GameFiles/Sprites/Obstacles/Buildings/RandomBuilding/BuildingWindow.tscn")
var win:Sprite2D  ## Scratch: each window being placed.

## Grid-fill the building face with windows between the given Y and X bounds (in steps of 82×52 px).
func decorationTime(y_start:float, y_end:float, x_start:float, x_end:float) -> void:
	for i in range(y_start + 50, y_end + 39, 82):
		for j in range(x_start + 32, x_end - 32, 52):
			win = B_Window.instantiate()
			win.position = Vector2(j, i)
			add_child(win)

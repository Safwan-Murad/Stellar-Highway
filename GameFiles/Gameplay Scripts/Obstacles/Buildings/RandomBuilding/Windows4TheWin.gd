extends Polygon2D

var B_Window:Resource = preload("res://GameFiles/Sprites/Obstacles/Buildings/RandomBuilding/BuildingWindow.tscn")
var win:Sprite2D

func decorationTime(y_start:float, y_end:float, x_start:float, x_end:float) -> void:
	for i in range(y_start + 50, y_end + 39, 82):
		for j in range(x_start + 32, x_end - 32, 52):
			win = B_Window.instantiate()
			win.position = Vector2(j, i)
			add_child(win)

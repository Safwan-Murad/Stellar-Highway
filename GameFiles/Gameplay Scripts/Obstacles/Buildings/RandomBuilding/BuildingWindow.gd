extends Sprite2D

static var ScrewConstantStrings:Array[Resource] = [
		preload("res://GameFiles/SpinHead IMGS/Buildings/Windows/0.png"),
		preload("res://GameFiles/SpinHead IMGS/Buildings/Windows/1.png"),
		preload("res://GameFiles/SpinHead IMGS/Buildings/Windows/2.png"),
		preload("res://GameFiles/SpinHead IMGS/Buildings/Windows/3.png"),
		preload("res://GameFiles/SpinHead IMGS/Buildings/Windows/4.png"),
		preload("res://GameFiles/SpinHead IMGS/Buildings/Windows/5.png"),
		preload("res://GameFiles/SpinHead IMGS/Buildings/Windows/6.png")
	]

func _ready() -> void:
	randomize()
	texture = ScrewConstantStrings[max(0, (randi() % 11) - 4)]

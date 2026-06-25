extends Sprite2D
## A single window on a procedural building. Picks a random window texture (lit or dark).
##
## The picker is weighted toward the darker textures so most windows look unlit. The texture
## list is a [code]static[/code] array so all windows share one cached copy (hence the joke name
## [member ScrewConstantStrings] — it avoids re-preloading the same paths per window).

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

extends Label

var stars:int = 0

func _ready() -> void:
	add_to_group("StarCnt")

func _process(_delta:float) -> void:
	text = str(stars)

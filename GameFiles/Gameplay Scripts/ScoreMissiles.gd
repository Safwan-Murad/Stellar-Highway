extends Label

var score:int = 0
var sc:int = 0
var of:int = 0

func _ready() -> void:
	add_to_group("Score")

func _process(_delta:float) -> void:
	sc = score
	text = str(sc)

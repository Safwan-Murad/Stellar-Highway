extends Label

@export var txt:String = "PRESS TO START "
var timeman:float = 0

func _process(delta:float) -> void:
	timeman += delta
	if timeman > 0.2:
		timeman = 0
		txt = txt.substr(1) + txt[0]
		text = txt

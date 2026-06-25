extends Label
## A scrolling marquee label (the "PRESS TO START" ticker).
##
## Every fraction of a second it rotates the string by one character, so the text appears
## to scroll sideways. ("p2s" = press-to-start.)

@export var txt:String = "PRESS TO START "  ## The looping marquee text (trailing space = gap).
var timeman:float = 0  ## Time accumulator controlling the scroll speed.

func _process(delta:float) -> void:
	timeman += delta
	if timeman > 0.2:
		timeman = 0
		txt = txt.substr(1) + txt[0]
		text = txt

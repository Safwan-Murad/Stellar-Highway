extends Label

var stars:int = 0
var Utils:Node2D

func _ready() -> void:
	add_to_group("Stars")
	Utils = get_tree().get_first_node_in_group("Utils")
	if Utils.loaded_data:
		if Utils.loaded_data.has("Stars"):
			stars = Utils.loaded_data["Stars"]

func _process(_delta:float) -> void:
	text = str(stars)

extends Label
## The player's persistent star balance (the "Stars" group).
##
## Loads the saved total on startup and displays it. This is the wallet the shop spends
## from when buying characters, and what the in-run StarCnt is added into on game over.

var stars:int = 0  ## The saved star balance.
var Utils:Node2D

func _ready() -> void:
	add_to_group("Stars")
	Utils = get_tree().get_first_node_in_group("Utils")
	if Utils.loaded_data:
		if Utils.loaded_data.has("Stars"):
			stars = Utils.loaded_data["Stars"]

func _process(_delta:float) -> void:
	text = str(stars)

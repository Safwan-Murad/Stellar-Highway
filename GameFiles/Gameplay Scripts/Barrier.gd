extends StaticBody2D
## Invisible wall trailing behind the player so you can't roll back forever.
##
## It only ever moves right (never left), creeping forward to stay a fixed distance
## behind the player. You can roll back a bit to retime obstacles, but not off the world.

@onready var player:CharacterBody2D = get_node("../Player")
@onready var parent:Node2D = get_node("../")

func _process(_delta:float) -> void:
	position.x = max(player.position.x - 400 - 1920 * parent.true_scalex/parent.true_scaley * 2.7, position.x)

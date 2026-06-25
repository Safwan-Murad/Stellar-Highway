extends Node2D
## Ramps the player's auto-run speed up the further they travel.
##
## Once the run has started ([code]minSpeed > 0[/code]), the minimum speed climbs with
## distance from 400 up to a cap of 1400, and the rolling speed cap follows. Frees
## itself once the cap is reached, since there's nothing left to do.

@onready var player:CharacterBody2D = get_node("../Player")
var offset:int  ## The player's starting X, so speed scales with distance travelled.

func _ready() -> void:
	offset = player.position.x

func _process(_delta:float) -> void:
	if player.minSpeed > 0:
		player.minSpeed = min(400 + (player.position.x - offset)/300, 1400)
		player.TOPROLL = 3 * (player.minSpeed + player.spdOffset)
		if player.minSpeed >= 1400:
			self.queue_free()

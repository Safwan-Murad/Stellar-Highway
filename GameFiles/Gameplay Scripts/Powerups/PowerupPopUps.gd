extends Label
## The powerup name banner (slot 0 of the "PowerupPopUps" group).
##
## Powerups set this label's text (e.g. "JETPACK") and play its pop-up animation to announce
## themselves. The group's other slots (1-5) are the persistent powerup HUD icons.

func _ready() -> void:
	add_to_group("PowerupPopUps")

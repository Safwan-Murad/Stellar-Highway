extends Sprite2D
## One powerup HUD icon (slots 1-5 of the "PowerupPopUps" group).
##
## Each active powerup toggles its own icon's visibility. The group is ordered:
## [0] name banner, [1] Rockstar, [2] Jetpack, [3] Doppelgänger, [4] Umbrella, [5] Lowrider.
## ("SP" = sprite, vs the slot-0 label.)

func _ready() -> void:
	add_to_group("PowerupPopUps")

extends StaticBody2D
## The spinning blades of a wind turbine. They start at a random speed and direction.
##
## Brushing the blades just knocks you around (not lethal); the danger is mistiming the gap and
## hitting the tower. Speed/direction are randomised by tweaking the spin animation's speed scale.

@onready var anim:AnimationPlayer = get_node("Spinner")

func _ready() -> void:
	randomize()
	# Random spin speed (1-3×) and a random direction (the ±1 factor).
	anim.speed_scale = randf_range(1, 3) * (-1 + 2 * (randi() % 2))

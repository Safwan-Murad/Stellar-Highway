extends Label
## The in-run score readout (Endless / Hole-in-a-Wall modes).
##
## Score is shown as "distance + bonus". [member sc] is raw distance travelled;
## [member of] is the bonus from stars (×100) plus any [member extra] (e.g. a clone's
## distance, Lowrider star pickups). The final saved score is [code]sc + of[/code].

var offset:int       ## The player's starting X, subtracted so distance starts at 0.
var extra:int = 0    ## Bonus points from sources other than stars (added by other scripts).
var sc:int = 0       ## Distance component of the score.
var of:int = 0       ## Bonus component of the score (stars×100 + extra).
@onready var player:CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var stars:Label = get_node("../Stars")

func _ready() -> void:
	add_to_group("Score")
	offset = player.position.x

func _process(_delta:float) -> void:
	sc = floor(player.position.x - offset)
	of = floor(extra + stars.stars * 100)
	text = str(sc) + "+" + str(of)

extends Label
## The Missiles-mode score readout.
##
## Unlike Endless mode there's no distance, so the score is just [member score], which
## MissileGenManager bumps up after each cleared wave. Shares the "Score" group and the
## same [member sc]/[member of] fields the game-over code reads.

var score:int = 0  ## Total score, increased per wave by MissileGenManager.
var sc:int = 0     ## Mirror of score (the value the game-over screen reads).
var of:int = 0     ## Unused here (kept for parity with the Endless-mode Score script).

func _ready() -> void:
	add_to_group("Score")

func _process(_delta:float) -> void:
	sc = score
	text = str(sc)

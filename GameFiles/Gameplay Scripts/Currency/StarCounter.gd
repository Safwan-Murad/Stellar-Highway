extends Label
## In-run star counter HUD. Holds the stars collected this run (the "StarCnt" group).
##
## Note this is the per-run tally; the persistent balance lives in the "Stars" group
## (see menuStars.gd / Utils.gd). On game over the two are reconciled and saved.

var stars:int = 0  ## Stars collected during the current run.

func _ready() -> void:
	add_to_group("StarCnt")

func _process(_delta:float) -> void:
	text = str(stars)

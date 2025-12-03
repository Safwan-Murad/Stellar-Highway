extends Line2D

var playerVel:int
var pnts:PackedVector2Array 
@export var mxSize:int = 16

func _ready() -> void:
	add_to_group("SpeedLine")

func _process(_delta:float) -> void:
	playerVel = get_node("../Player").vel
	mxSize = round(playerVel / 50) 
	pnts = points
	if playerVel >= 600:
		if pnts.size() < mxSize:
			pnts.push_back(get_node("../Player").position)
		if pnts.size() >= mxSize:
			pnts.remove_at(0)
	elif pnts.size() > 1:
		pnts.remove_at(0)
		for i in range(pnts.size() - 1):
			pnts[i] = pnts[i+1]
		pnts[pnts.size() - 1] = get_node("../Player").position
	elif pnts.size() == 1:
		pnts.remove_at(0)
	set_points(pnts)

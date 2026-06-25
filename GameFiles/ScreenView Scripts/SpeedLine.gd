extends Line2D
## The motion trail that streaks behind the player at high speed.
##
## Above ~600 speed it grows a tail of recent player positions (length scales with speed);
## below that it shrinks the tail back to nothing. The trail's colour/offset is set per
## character by player_physics.gd. Lives in the "SpeedLine" group.

var playerVel:int   ## The player's current speed this frame.
var pnts:PackedVector2Array  ## Working copy of the trail points.
@export var mxSize:int = 16  ## Max trail length in points (recomputed from speed).
@onready var player:Node2D = get_node("../Player")  ## Cached once; was fetched up to 3x per frame.

func _ready() -> void:
	add_to_group("SpeedLine")

func _process(_delta:float) -> void:
	playerVel = player.vel
	mxSize = round(playerVel / 50)
	pnts = points
	if playerVel >= 600:
		if pnts.size() < mxSize:
			pnts.push_back(player.position)
		if pnts.size() >= mxSize:
			pnts.remove_at(0)
	elif pnts.size() > 1:
		pnts.remove_at(0)
		for i in range(pnts.size() - 1):
			pnts[i] = pnts[i+1]
		pnts[pnts.size() - 1] = player.position
	elif pnts.size() == 1:
		pnts.remove_at(0)
	set_points(pnts)

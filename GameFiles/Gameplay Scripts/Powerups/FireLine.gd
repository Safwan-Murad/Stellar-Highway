extends Line2D
## The flame trail drawn behind the Jetpack.
##
## While [member active] it mirrors the last few points of the player's speed trail, shrunk
## and re-oriented to the player's rotation, so the jetpack appears to leave a short jet of
## fire. Activated by Jetpack.gd on pickup.

var active:bool = false  ## Whether the jetpack is on and this trail should draw.
var spdLine:Line2D       ## The player's speed trail this borrows points from.
var player:CharacterBody2D
var pnts:PackedVector2Array  ## Working copy of the trail points.
var offset:Vector2           ## The trail's tail position, used to localise the points.


func _ready() -> void:
	spdLine = get_tree().get_first_node_in_group("SpeedLine")
	player = get_tree().get_first_node_in_group("Player")

## Build the short flame from the tail of the player's speed trail: take the last few trail
## points, move them so the tip sits at the origin, halve their length, and flatten the X by the
## player's rotation so the flame leans the right way behind the jetpack.
func _process(_delta:float) -> void:
	if active:
		pnts = spdLine.points
		if pnts.size() > 1:
			offset = pnts[pnts.size() - 1]
			if pnts.size() >= 4 :
				pnts = pnts.slice(-4)
			for i in range(pnts.size()):
				pnts[i] -= offset
				pnts[i] /= 2
				pnts[i].x *= cos(player.rotation)
		set_points(pnts)

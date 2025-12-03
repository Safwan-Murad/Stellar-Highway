extends Line2D

var active:bool = false
var spdLine:Line2D
var player:CharacterBody2D
var pnts:PackedVector2Array
var offset:Vector2


func _ready() -> void:
	spdLine = get_tree().get_first_node_in_group("SpeedLine")
	player = get_tree().get_first_node_in_group("Player")

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

extends Line2D

var pnts:Array = []
var rt:float
@onready var fusePars:CPUParticles2D = get_node("../../FusePars")

func _ready() -> void:
	randomize()
	rt = randf_range(0.133, 0.175)
	for i in range(30):
		pnts.push_back(Vector2(i*1.5, 0))
	set_points(pnts)
	
	for i in range(30):
		pnts.pop_back()
		set_points(pnts)
		if pnts:
			fusePars.position = pnts[pnts.size()-1] * 2
		await get_tree().create_timer(rt).timeout
	
	get_node("../../").gg1()

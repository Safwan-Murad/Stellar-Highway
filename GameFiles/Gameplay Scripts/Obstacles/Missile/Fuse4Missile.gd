extends Line2D
## The burning fuse on a timed missile — a countdown rendered as a shrinking line.
##
## Draws a 30-segment fuse and burns it down one segment at a time over a random interval,
## moving the spark particles to the burning tip. When the fuse runs out it calls the parent
## missile's [code]gg1()[/code] to detonate.

var pnts:Array = []  ## The fuse's remaining points (popped as it burns).
var rt:float         ## Seconds between burning each segment (randomised per missile).
@onready var fusePars:CPUParticles2D = get_node("../../FusePars")  ## The spark particles at the tip.

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

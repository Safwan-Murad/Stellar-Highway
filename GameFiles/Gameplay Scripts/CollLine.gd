extends StaticBody2D

var disTime:float = 3.0
var sus:bool = true

func _process(delta:float):
	disTime-=delta
	
	if disTime <= 0 and is_instance_valid(self) and sus:
		sus = false
		killMe4FreeRAM()

func _on_area_2d_body_exited(body):
	if body.name == "Player" and is_instance_valid(self) and sus:
		sus = false
		killMe4FreeRAM()

func killMe4FreeRAM():
	var tween:Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.3)
	tween.tween_callback(queue_free)

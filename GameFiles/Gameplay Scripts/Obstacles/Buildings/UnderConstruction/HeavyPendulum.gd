extends StaticBody2D

@onready var ThetaMax:float = 0.003
var acc:float
var vel:float = 0.0
var cnt:float = 0.0

func _physics_process(delta:float) -> void:
	cnt += delta
	if cnt > 0.02:
		cnt = 0.0
		acc = -ThetaMax*sin(rotation)
		vel += acc
		rotation += vel

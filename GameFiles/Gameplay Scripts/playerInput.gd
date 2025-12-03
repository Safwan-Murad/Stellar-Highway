extends Node2D

var first:bool = false
var is_pre:bool = false
var oldpos:Vector2 = Vector2(0, 0)
var newpos:Vector2 = Vector2(0, 0)
var tpos:Vector2 = Vector2(0, 0)
var Line:Resource = preload("res://GameFiles/Sprites/CollLine.tscn")
var Star:Resource = preload("res://GameFiles/Sprites/Currency/Star.tscn")
var lineTemp:StaticBody2D
var stTemp:Node2D
var switch:bool = false
var powerup:bool = false

func _ready() -> void:
	add_to_group("playerInput")

func _process(_delta:float) -> void:
	if is_pre:
		if not first:
			newpos = get_canvas_transform().affine_inverse().translated(tpos).origin
			if abs(newpos.distance_to(oldpos)) > 15:
				lineTemp = Line.instantiate()
				lineTemp.position = oldpos
				add_child(lineTemp)
				lineTemp.get_node("Line2D").add_point(newpos-oldpos)
				lineTemp.get_node("CollisionShape2D").shape = SegmentShape2D.new()
				lineTemp.get_node("CollisionShape2D").shape.b = newpos-oldpos
				lineTemp.get_node("Area2D").get_node("CollisionShape2D").shape = lineTemp.get_node("CollisionShape2D").shape
				if switch and powerup:
					stTemp = Star.instantiate()
					lineTemp.add_child(stTemp)
				oldpos = newpos
				switch = not switch
		else:
			first = false
			#oldpos = tpos
	else:
		first = true

func _input(event:InputEvent) -> void:
	if event is InputEventScreenDrag and event.index == 0:
		tpos = event.position
		newpos = get_canvas_transform().affine_inverse().translated(tpos).origin
		if newpos.y > 1082 or newpos.y < -2:
			is_pre = false
	
	elif event is InputEventScreenTouch:
		if  event.is_pressed() and event.index == 0:
			tpos = event.position
			oldpos = get_canvas_transform().affine_inverse().translated(tpos).origin
			newpos = oldpos
			if oldpos.y > 1082 or oldpos.y < -2:
				is_pre = false
			else:
				is_pre = true
		elif event.index == 0:
			is_pre = false

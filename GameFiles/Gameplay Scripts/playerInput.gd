extends Node2D
## Turns pointer input into the solid terrain the character rolls on.
##
## While a finger/stylus/mouse is pressed and dragging on the play area, this samples
## the pointer in world space and, every ~15 px of travel, drops a [code]CollLine[/code]
## segment — a visible line plus a [SegmentShape2D] collider. Supports touch, the S Pen
## (which arrives as mouse events on Android) and the mouse. When the Rockstar powerup
## is active, stars are scattered along the drawn line. Lives in the "playerInput" group.

var first:bool = false      ## True on the first frame of a new stroke (skips drawing a stray segment).
var is_pre:bool = false     ## True while actively drawing (pointer down inside the play area).
var oldpos:Vector2 = Vector2(0, 0)  ## World position of the last placed point.
var newpos:Vector2 = Vector2(0, 0)  ## World position of the current pointer sample.
var tpos:Vector2 = Vector2(0, 0)    ## Latest raw (screen-space) pointer position.
var Line:Resource = preload("res://GameFiles/Sprites/CollLine.tscn")
var Star:Resource = preload("res://GameFiles/Sprites/Currency/Star.tscn")
var lineTemp:StaticBody2D   ## The segment currently being instantiated.
var stTemp:Node2D           ## Scratch star instance.
var switch:bool = false     ## Alternates so stars are placed on every other segment, not all.
var powerup:bool = false    ## True while the Rockstar powerup is active (enables star drawing).

func _ready() -> void:
	add_to_group("playerInput")

## Each frame, if drawing, extend the line: once the pointer has moved >15 px from the
## last point, spawn a new collider segment between them (and maybe a star).
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

## Tracks pointer state across the three input kinds. Pressing inside the play area
## starts a stroke (is_pre = true); releasing, or dragging off the top/bottom edge,
## ends it. The actual segment creation happens in _process.
func _input(event:InputEvent) -> void:
	# Touch drag (finger / non-S Pen)
	if event is InputEventScreenDrag and event.index == 0:
		tpos = event.position
		newpos = get_canvas_transform().affine_inverse().translated(tpos).origin
		if newpos.y > 1082 or newpos.y < -2:
			is_pre = false

	elif event is InputEventScreenTouch:
		if event.is_pressed() and event.index == 0:
			tpos = event.position
			oldpos = get_canvas_transform().affine_inverse().translated(tpos).origin
			newpos = oldpos
			if oldpos.y > 1082 or oldpos.y < -2:
				is_pre = false
			else:
				is_pre = true
		elif event.index == 0:
			is_pre = false

	# S Pen (and mouse) support — stylus reports as mouse events on Android
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			tpos = event.position
			oldpos = get_canvas_transform().affine_inverse().translated(tpos).origin
			newpos = oldpos
			if oldpos.y > 1082 or oldpos.y < -2:
				is_pre = false
			else:
				is_pre = true
		else:
			is_pre = false

	elif event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_LEFT:
		tpos = event.position
		newpos = get_canvas_transform().affine_inverse().translated(tpos).origin
		if newpos.y > 1082 or newpos.y < -2:
			is_pre = false

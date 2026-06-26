extends Node2D
## Turns pointer input into the smooth, solid terrain the character rolls on.
##
## While a finger/stylus/mouse is pressed and dragging on the play area, this samples the
## pointer in world space and, every [constant SAMPLE_DISTANCE] px of travel, commits a point.
## Committed points are joined with a quadratic-Bézier curve (see [method _commit_point]) so the
## collision the character rides is smoothly rounded instead of a chain of sharp corners. Each
## curve piece is a [code]CollLine[/code] segment — a visible line plus a [SegmentShape2D]
## collider. Supports touch, the S Pen (which arrives as mouse events on Android) and the mouse.
## When the Rockstar powerup is active, stars are scattered along the drawn line. Lives in the
## "playerInput" group.

## Minimum pointer travel (px) before a new curve point is committed. Lower = the line hugs the
## finger more closely (and makes more segments); higher = coarser sampling.
const SAMPLE_DISTANCE := 15.0

## How many straight pieces each smoothed chord is split into. 1 = corner-cutting only (no extra
## line nodes vs. the old behaviour); 2-4 = progressively rounder curves at a linear cost in line
## nodes. If drawing ever hitches on a low-end phone, drop this to 1 (or add object pooling).
const SMOOTH_SUBDIVISIONS := 2

## Assist draw: how far above the finger (px) the drawn line appears, so your hand doesn't cover
## the action. 0 = classic (line directly under the pointer). This is the mechanic for the
## accessibility option; expose it through a menu toggle to let players opt in.
const DRAW_OFFSET := 0.0

## Whether to emit a small spark at the drawing tip during fast play. Purely cosmetic.
const SPARKLES := true

var first:bool = false      ## True on the first frame of a new stroke (skips drawing a stray segment).
var is_pre:bool = false     ## True while actively drawing (pointer down inside the play area).
var oldpos:Vector2 = Vector2(0, 0)      ## World position of the last committed point.
var anchorPrev:Vector2 = Vector2(0, 0)  ## The point before oldpos, used to round the corner at oldpos.
var newpos:Vector2 = Vector2(0, 0)      ## World position of the current pointer sample.
var tpos:Vector2 = Vector2(0, 0)        ## Latest raw (screen-space) pointer position.
var Line:Resource = preload("res://GameFiles/Sprites/CollLine.tscn")
var Star:Resource = preload("res://GameFiles/Sprites/Currency/Star.tscn")
var lineTemp:StaticBody2D   ## The segment currently being instantiated.
var stTemp:Node2D           ## Scratch star instance.
var switch:bool = false     ## Alternates so stars are placed on every other chord, not all.
var powerup:bool = false    ## True while the Rockstar powerup is active (enables star drawing).
var sparks:CPUParticles2D   ## Optional spark emitter that follows the drawing tip.

func _ready() -> void:
	add_to_group("playerInput")
	if SPARKLES:
		_make_sparks()

## Converts a screen-space pointer position to a world position, applying the assist-draw offset
## so the line can be lifted above the finger when DRAW_OFFSET is non-zero.
func _world(screen_pos:Vector2) -> Vector2:
	return get_canvas_transform().affine_inverse().translated(screen_pos).origin - Vector2(0, DRAW_OFFSET)

## Gives a freshly-created segment its look: a stroke that thickens with the player's speed and an
## ink colour matched to the selected character's trail. Purely cosmetic — the segment's collider
## is set up independently, so this can't affect how the line plays.
func _style_segment(ln:Line2D) -> void:
	var pl:Node = Refs.player()
	if pl == null:
		return
	ln.width = clamp(3.5 + pl.vel / 300.0, 3.5, 8.0)
	if pl.trail:
		ln.default_color = pl.trail.default_color

## Each frame, if drawing, sample the pointer and commit a new curve point once it has moved more
## than SAMPLE_DISTANCE from the last one.
func _process(_delta:float) -> void:
	if is_pre:
		if not first:
			newpos = _world(tpos)
			if abs(newpos.distance_to(oldpos)) > SAMPLE_DISTANCE:
				_commit_point(newpos)
		else:
			first = false
			anchorPrev = oldpos
	else:
		first = true
	_update_sparks()

## Commits a new point and lays down the smoothed terrain leading up to it.
##
## The corner at [member oldpos] is rounded with a quadratic Bézier whose endpoints are the
## midpoints of the neighbouring chords and whose control point is oldpos itself. Because
## consecutive chords share those midpoints, the pieces join with no gaps (this is Chaikin-style
## corner cutting); the drawn line therefore trails the finger by about half a chord, which is
## imperceptible at SAMPLE_DISTANCE px.
func _commit_point(p_new:Vector2) -> void:
	var start:Vector2 = (anchorPrev + oldpos) * 0.5
	var ctrl:Vector2 = oldpos
	var end:Vector2 = (oldpos + p_new) * 0.5
	var place_star:bool = powerup and switch
	var prev_pt:Vector2 = start
	for i in range(1, SMOOTH_SUBDIVISIONS + 1):
		var t:float = float(i) / SMOOTH_SUBDIVISIONS
		var pt:Vector2 = _quad_bezier(start, ctrl, end, t)
		var seg:StaticBody2D = _emit_segment(prev_pt, pt)
		# Put the (optional) star on the last piece of this chord.
		if place_star and i == SMOOTH_SUBDIVISIONS:
			stTemp = Star.instantiate()
			seg.add_child(stTemp)
		prev_pt = pt
	anchorPrev = oldpos
	oldpos = p_new
	switch = not switch

## Instantiates one CollLine segment from world point [param a] to [param b] and returns it.
func _emit_segment(a:Vector2, b:Vector2) -> StaticBody2D:
	lineTemp = Line.instantiate()
	lineTemp.position = a
	add_child(lineTemp)
	var ln:Line2D = lineTemp.get_node("Line2D")
	ln.add_point(b - a)
	_style_segment(ln)
	var shape:SegmentShape2D = SegmentShape2D.new()
	shape.b = b - a
	lineTemp.get_node("CollisionShape2D").shape = shape
	lineTemp.get_node("Area2D").get_node("CollisionShape2D").shape = shape
	return lineTemp

## A point on the quadratic Bézier defined by [param p0], [param p1] (control) and [param p2].
func _quad_bezier(p0:Vector2, p1:Vector2, p2:Vector2, t:float) -> Vector2:
	return p0.lerp(p1, t).lerp(p1.lerp(p2, t), t)

## Builds the (lazy) spark emitter that trails the drawing tip during fast play.
func _make_sparks() -> void:
	sparks = CPUParticles2D.new()
	sparks.emitting = false
	sparks.local_coords = false   # sparks stay where they were emitted as the tip moves on
	sparks.amount = 12
	sparks.lifetime = 0.4
	sparks.spread = 180.0
	sparks.initial_velocity_min = 20.0
	sparks.initial_velocity_max = 90.0
	sparks.gravity = Vector2(0, 220)
	sparks.scale_amount_min = 1.0
	sparks.scale_amount_max = 2.0
	sparks.z_index = 3
	add_child(sparks)

## Each frame, emit sparks at the drawing tip only while drawing at speed, tinted to the character.
func _update_sparks() -> void:
	if sparks == null:
		return
	var pl:Node = Refs.player()
	var fast:bool = pl != null and pl.vel > 600
	sparks.emitting = is_pre and fast
	if is_pre:
		sparks.position = newpos
		if pl != null and pl.trail:
			sparks.color = pl.trail.default_color

## Tracks pointer state across the three input kinds. Pressing inside the play area starts a
## stroke (is_pre = true); releasing, or dragging off the top/bottom edge, ends it. The actual
## segment creation happens in _process.
func _input(event:InputEvent) -> void:
	# Touch drag (finger / non-S Pen)
	if event is InputEventScreenDrag and event.index == 0:
		tpos = event.position
		newpos = _world(tpos)
		if newpos.y > 1082 or newpos.y < -2:
			is_pre = false

	elif event is InputEventScreenTouch:
		if event.is_pressed() and event.index == 0:
			tpos = event.position
			oldpos = _world(tpos)
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
			oldpos = _world(tpos)
			newpos = oldpos
			if oldpos.y > 1082 or oldpos.y < -2:
				is_pre = false
			else:
				is_pre = true
		else:
			is_pre = false

	elif event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_LEFT:
		tpos = event.position
		newpos = _world(tpos)
		if newpos.y > 1082 or newpos.y < -2:
			is_pre = false

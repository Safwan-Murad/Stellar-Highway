extends Node2D
## A "Wall-o-Bats": one or more vertical walls of bats, each with a single gap to fit through.
##
## Builds 1-4 columns; each column is 25 bats tall except for a randomly placed gap (marked
## with stars so you can see the safe path). The whole wall scrolls left toward the player.
## Used both in Endless mode and as the main obstacle of Hole-in-a-Wall mode (see WallGenManager,
## which sets [member wall_dist]/[member difficulty] to tighten and speed up walls over time).

var offx:int = 1920       ## Despawn clearance distance (depends on how many columns spawned).
var wall_dist:int = 1920  ## Horizontal spacing between columns.

var walls:int             ## Number of columns in this wall (1-4).
var dontman:int           ## Row index of the gap in the current column.
var velocity:float = 1.0  ## Base leftward scroll speed.
var difficulty:float = 1.0 ## Scroll-speed multiplier (raised for later walls).
var WallBat:Resource = preload("res://GameFiles/Sprites/Obstacles/WalloBats/WallBat.tscn")
var Star:Resource = preload("res://GameFiles/Sprites/Currency/Star.tscn")
var wb:Node2D             ## Scratch: each bat or star being placed.

func _ready() -> void:
	randomize()
	walls = randi()%4 + 1
	offx = (walls - 1) * wall_dist + 1024
	for i in range(walls):
		dontman = randi()%22 + 1
		for j in range(25):
			# Near the gap row, place stars (the safe path); elsewhere, place a deadly bat.
			if abs(j - dontman) <= 2:
				wb = Star.instantiate()
			else:
				wb = WallBat.instantiate()
			wb.position = Vector2(i*wall_dist, j*45)
			add_child(wb)

func _process(_delta:float) -> void:
	position.x -= velocity * difficulty

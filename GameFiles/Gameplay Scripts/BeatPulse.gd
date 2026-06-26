extends Node2D
## Gives the moon a subtle throb to the music beat. Attached to the root of BG.tscn.
##
## The main beat-reactive effect is the stage-light beams (see SpotlightBeat.gd); this just adds a
## little life to the moon. The skyline is deliberately left untouched — brightening the whole
## parallax layer read as a flat, half-screen flash. Reads the shared beat from [code]Settings[/code].

const THROB := 0.08  ## Fraction the moon grows at a full beat. Keep it subtle.

@onready var moon: Node2D = get_node_or_null("Moon/Moon/Moon")
var moon_base: Vector2 = Vector2.ONE  ## The moon's resting scale, so the throb is relative.

func _ready() -> void:
	if moon:
		moon_base = moon.scale

func _process(_delta: float) -> void:
	if moon:
		moon.scale = moon_base * (1.0 + Settings.beat * THROB)

extends Sprite2D
## Pulses a stage-light beam to the music beat — the main beat-reactive visual.
##
## Attached to the [code]LightSource[/code] beam inside LightProjector.tscn. Between beats the beam
## sits a little dimmer; on each beat it brightens to full and stretches, like concert lighting
## reacting to the soundtrack. The beam's side-to-side swing (its rotation) is animated separately,
## so this only touches brightness and scale. Reads the shared beat from [code]Settings[/code].

const STRETCH := 0.12     ## How much longer/wider the beam gets at a full beat.
const REST_ALPHA := 0.78  ## Beam opacity between beats, relative to its resting alpha (1.0 = no dip).

var base_scale: Vector2
var base_alpha: float

func _ready() -> void:
	base_scale = scale
	base_alpha = self_modulate.a

func _process(_delta: float) -> void:
	var beat: float = Settings.beat
	scale = base_scale * (1.0 + beat * STRETCH)
	self_modulate.a = base_alpha * lerp(REST_ALPHA, 1.0, beat)

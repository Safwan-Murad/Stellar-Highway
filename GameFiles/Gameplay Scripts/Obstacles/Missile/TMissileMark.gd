extends Node2D
## The proximity warning for timed missiles — the audio-only twin of MissileMark.
##
## Same nearest-missile beep logic, but tracks the "TMissiles" group and has no on-player
## marker (timed missiles can't be steered into anything, so there's nothing to aim). Frees
## itself once no timed missiles remain.

var cooldown:float = 0.2  ## Delay between beeps; scales down as the missile nears.
@onready var sound_player:AudioStreamPlayer2D = get_node("MissileBeep")
@onready var player:CharacterBody2D = get_node("../Player")
var missilePos:Vector2  ## Position of the nearest timed missile.
var missiles:Array      ## All live timed missiles this frame.

func _process(_delta:float) -> void:
	missiles = get_tree().get_nodes_in_group("TMissiles")
	if missiles.size() > 0:
		missilePos = missiles[0].position
	else:
		self.queue_free()
	for missile in missiles:
		if missile.position.distance_to(player.position) < missilePos.distance_to(player.position):
			missilePos = missile.position
	cooldown = min(0.0002 * missilePos.distance_to(player.position), 0.2)
	sound_player.position = missilePos

func _on_missile_beep_finished() -> void:
		sound_player.play()

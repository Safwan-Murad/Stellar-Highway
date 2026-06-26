extends Node
## Autoloaded as [code]Settings[/code]: persisted player preferences and the code that applies them.
##
## Settings are stored as JSON in [code]user://settings.bin[/code], loaded once on startup and
## applied to the engine (audio bus volumes, etc.). Writes are atomic (temp file + swap) and reads
## are validated, mirroring [code]Utils.gd[/code] — a missing or corrupt file just falls back to the
## defaults below rather than crashing.
##
## UI wiring is intentionally tiny: a control calls [method set_value] with a key + value, and this
## node persists and applies it. Read a value straight off the property (e.g. [member draw_offset]).

const PATH := "user://settings.bin"

var music_volume: float = 1.0   ## 0..1, applied to the "Music" audio bus (1.0 = no change).
var haptics_on: bool = true     ## Whether to buzz on hits/pickups (Android; a no-op elsewhere).
var draw_offset: float = 0.0    ## Assist draw: pixels the drawn line sits above the finger. 0 = classic.

# Beat detection: read the bass energy off the Music bus and smooth it into a 0..1 "beat" value
# that reactive visuals (the stage lights, the moon) read each frame.
const BEAT_GAIN := 28.0       ## Scales the small raw bass magnitude up into 0..1. Tune to taste.
const BEAT_SMOOTHING := 0.25  ## How quickly [member beat] follows the music (higher = snappier).

var beat: float = 0.0  ## Smoothed bass envelope, 0..1. Read by BeatPulse.gd / SpotlightBeat.gd.
var _music_analyzer: AudioEffectSpectrumAnalyzerInstance  ## Reads the music's spectrum.

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS  # keep the beat live even while the game is paused
	_load()
	_apply()
	_setup_analyzer()

func _process(_delta: float) -> void:
	if _music_analyzer == null:
		return
	var mag: float = _music_analyzer.get_magnitude_for_frequency_range(30.0, 130.0).length()
	beat = lerp(beat, clamp(mag * BEAT_GAIN, 0.0, 1.0), BEAT_SMOOTHING)

## Puts a spectrum analyzer on the Music bus and caches its instance, so visuals can pulse to the
## beat. Safe to call once; does nothing if the bus is missing.
func _setup_analyzer() -> void:
	var music: int = AudioServer.get_bus_index("Music")
	if music < 0:
		return
	if AudioServer.get_bus_effect_count(music) == 0:
		AudioServer.add_bus_effect(music, AudioEffectSpectrumAnalyzer.new())
	var inst = AudioServer.get_bus_effect_instance(music, 0)
	if inst is AudioEffectSpectrumAnalyzerInstance:
		_music_analyzer = inst

## Pushes the current settings into the engine. Safe to call repeatedly.
func _apply() -> void:
	var music:int = AudioServer.get_bus_index("Music")
	if music >= 0:
		# Clamp away from 0 so linear_to_db doesn't return -inf; ~0 is effectively silent.
		AudioServer.set_bus_volume_db(music, linear_to_db(clamp(music_volume, 0.0001, 1.0)))

## Changes one setting by [param key], then applies + persists it. Unknown keys are ignored.
func set_value(key: String, value) -> void:
	match key:
		"music_volume": music_volume = float(value)
		"haptics_on": haptics_on = bool(value)
		"draw_offset": draw_offset = float(value)
	_apply()
	_save()

## Short haptic buzz of [param ms] milliseconds — a no-op when haptics are off or unsupported.
func vibrate(ms: int) -> void:
	if haptics_on:
		Input.vibrate_handheld(ms)

## Reads + validates the settings file, keeping defaults for anything missing or malformed.
func _load() -> void:
	if not FileAccess.file_exists(PATH):
		return
	var file: FileAccess = FileAccess.open(PATH, FileAccess.READ)
	if file == null or file.eof_reached():
		return
	var parsed = JSON.parse_string(file.get_line())
	if parsed is Dictionary:
		music_volume = float(parsed.get("music_volume", music_volume))
		haptics_on = bool(parsed.get("haptics_on", haptics_on))
		draw_offset = float(parsed.get("draw_offset", draw_offset))

## Writes the settings atomically (temp file, then swap) so an interrupted write can't corrupt them.
func _save() -> void:
	var data: Dictionary = {
		"music_volume": music_volume,
		"haptics_on": haptics_on,
		"draw_offset": draw_offset,
	}
	var tmp_path: String = PATH + ".tmp"
	var file: FileAccess = FileAccess.open(tmp_path, FileAccess.WRITE)
	if file == null:
		return
	file.store_line(JSON.stringify(data))
	file.close()
	var dir: DirAccess = DirAccess.open("user://")
	if dir == null:
		return
	var fname: String = PATH.get_file()
	if dir.file_exists(fname):
		dir.remove(fname)
	dir.rename(tmp_path.get_file(), fname)

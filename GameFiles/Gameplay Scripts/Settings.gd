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
var shake_on: bool = true       ## Whether the camera shakes on impacts (see Refs.shake).
var draw_offset: float = 0.0    ## Assist draw: pixels the drawn line sits above the finger. 0 = classic.

func _ready() -> void:
	_load()
	_apply()

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
		"shake_on": shake_on = bool(value)
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
		shake_on = bool(parsed.get("shake_on", shake_on))
		draw_offset = float(parsed.get("draw_offset", draw_offset))

## Writes the settings atomically (temp file, then swap) so an interrupted write can't corrupt them.
func _save() -> void:
	var data: Dictionary = {
		"music_volume": music_volume,
		"haptics_on": haptics_on,
		"shake_on": shake_on,
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

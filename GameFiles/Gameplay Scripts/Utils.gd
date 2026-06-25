extends Node2D
## Persistence: reads and writes the player's save data and high scores.
##
## Two JSON files under Godot's [code]user://[/code] directory:
## [br]• [code]savefile.bin[/code]  — { playerCharacter, Stars, ownedChars[6] }
## [br]• [code]scorefile.bin[/code] — { "0", "1", "2" } high score per game mode
## [br]Reached by other scripts via the "Utils" group.

var SAVE_PATH:String = "user://savefile.bin"   ## Character selection, star balance, owned characters.
var SCORE_PATH:String = "user://scorefile.bin" ## Per-mode high scores.
var loaded_data:Dictionary  ## In-memory copy of savefile.bin.
var scores:Dictionary       ## In-memory copy of scorefile.bin.
var tempStars:int = 0       ## Scratch used to fold a star delta into the saved balance.

func _ready() -> void:
	add_to_group("Utils")
	loadgame()

## Writes the save file. [param selChar] is the selected character; [param stars] is a
## delta added to the saved balance (negative when buying a character); [param ownedChars]
## overrides the owned-character flags (kept as-is when null).
func savegame(selChar:int, stars:int = 0, ownedChars = null) -> void:
	if loaded_data:
		if loaded_data.has("Stars"):
			tempStars = loaded_data["Stars"] + stars
		else:
			tempStars = stars
		if loaded_data.has("ownedChars") and ownedChars == null:
			ownedChars = loaded_data["ownedChars"]
	else:
		tempStars = stars
	if ownedChars == null:
		ownedChars = [1, 0, 0, 0, 0, 0]
	var data:Dictionary = {
		"playerCharacter": selChar,
		"Stars": tempStars,
		"ownedChars": ownedChars
	}
	loaded_data = data
	_store_json(SAVE_PATH, data)

## Records [param score] as the high score for [param gamemode] (0-2), keeping the
## existing best if it's higher.
func saveScore(score:int, gamemode:int) -> void:
	var games:Array = [0, 0, 0]
	if scores:
		for i in range(games.size()):
			if scores.has(str(i)):
				games[i] = scores[str(i)]

	games[gamemode] = max(games[gamemode], score)
	var data1:Dictionary = {
		"0": games[0],
		"1": games[1],
		"2": games[2]
	}
	scores = data1
	_store_json(SCORE_PATH, data1)

## Loads both save files into memory on startup (if they exist).
## Each file is parsed independently and only adopted if it's a valid JSON object,
## so a missing or corrupt file falls back to defaults instead of crashing.
func loadgame() -> void:
	var parsed = _read_json(SAVE_PATH)
	if parsed is Dictionary:
		loaded_data = parsed
	var parsed_scores = _read_json(SCORE_PATH)
	if parsed_scores is Dictionary:
		scores = parsed_scores

## Reads and JSON-parses one save file, returning the parsed value or null if the
## file is absent, empty or unreadable. Never throws on a missing/corrupt file.
func _read_json(path:String):
	if not FileAccess.file_exists(path):
		return null
	var file:FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null or file.eof_reached():
		return null
	return JSON.parse_string(file.get_line())

## Writes [param data] as JSON to [param path] atomically: it writes a temporary
## file first and only swaps it into place once the write fully succeeds, so an app
## kill mid-write can't corrupt an existing save (it just keeps the previous one).
func _store_json(path:String, data:Dictionary) -> void:
	var tmp_path:String = path + ".tmp"
	var file:FileAccess = FileAccess.open(tmp_path, FileAccess.WRITE)
	if file == null:
		return
	file.store_line(JSON.stringify(data))
	file.close() # flush to disk before the swap
	var dir:DirAccess = DirAccess.open("user://")
	if dir == null:
		return
	var fname:String = path.get_file()
	var tmp_fname:String = tmp_path.get_file()
	if dir.file_exists(fname):
		dir.remove(fname)
	dir.rename(tmp_fname, fname)

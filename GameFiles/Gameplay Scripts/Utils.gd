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
	var file:FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
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
	var jstr:String = JSON.stringify(data)
	file.store_line(jstr)

## Records [param score] as the high score for [param gamemode] (0-2), keeping the
## existing best if it's higher.
func saveScore(score:int, gamemode:int) -> void:
	var file1:FileAccess = FileAccess.open(SCORE_PATH, FileAccess.WRITE)
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
	var jstr1:String = JSON.stringify(data1)
	file1.store_line(jstr1)

## Loads both save files into memory on startup (if they exist).
func loadgame() -> void:
	var file:FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH):
		if not file.eof_reached():
			loaded_data = JSON.parse_string(file.get_line())
	var file1 = FileAccess.open(SCORE_PATH, FileAccess.READ)
	if FileAccess.file_exists(SCORE_PATH):
		if not file.eof_reached():
			scores = JSON.parse_string(file1.get_line())

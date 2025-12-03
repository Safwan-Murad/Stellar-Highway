extends Node2D

var SAVE_PATH:String = "user://savefile.bin"
var SCORE_PATH:String = "user://scorefile.bin"
var loaded_data:Dictionary
var scores:Dictionary
var tempStars:int = 0

func _ready() -> void:
	add_to_group("Utils")
	loadgame()

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

func loadgame() -> void:
	var file:FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH):
		if not file.eof_reached():
			loaded_data = JSON.parse_string(file.get_line())
	var file1 = FileAccess.open(SCORE_PATH, FileAccess.READ)
	if FileAccess.file_exists(SCORE_PATH):
		if not file.eof_reached():
			scores = JSON.parse_string(file1.get_line())

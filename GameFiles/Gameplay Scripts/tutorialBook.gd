extends Control

@onready var shady:Sprite2D = get_node("ShadyBusiness")
@onready var bookPics:Sprite2D = get_node("PageBg/bookPics")
@onready var pageNum:Label = get_node("PageBg/pageNum")
@onready var readnLearn:RichTextLabel = get_node("PageBg/readnLearn")
var currPage:int = 0
var noSpam:bool = true

var pics:Array[Resource] = [
	preload("res://GameFiles/SpinHead IMGS/UI/menu/tutorialBook/tutPics/0.png"),
	preload("res://GameFiles/SpinHead IMGS/UI/menu/tutorialBook/tutPics/0.5.png"),
	preload("res://GameFiles/SpinHead IMGS/UI/menu/tutorialBook/tutPics/0.6.png"),
	preload("res://GameFiles/SpinHead IMGS/UI/menu/tutorialBook/tutPics/0.7.png"),
	preload("res://GameFiles/SpinHead IMGS/UI/menu/tutorialBook/tutPics/1.png"),
	preload("res://GameFiles/SpinHead IMGS/UI/menu/tutorialBook/tutPics/8.png"),
	preload("res://GameFiles/SpinHead IMGS/UI/menu/tutorialBook/tutPics/3.png"),
	preload("res://GameFiles/SpinHead IMGS/UI/menu/tutorialBook/tutPics/4.png"),
	preload("res://GameFiles/SpinHead IMGS/UI/menu/tutorialBook/tutPics/5.png"),
	preload("res://GameFiles/SpinHead IMGS/UI/menu/tutorialBook/tutPics/6.png"),
	preload("res://GameFiles/SpinHead IMGS/UI/menu/tutorialBook/tutPics/7.png"),
	preload("res://GameFiles/SpinHead IMGS/UI/menu/tutorialBook/tutPics/2.png"),
	preload("res://GameFiles/SpinHead IMGS/UI/menu/tutorialBook/tutPics/9.png"),
	preload("res://GameFiles/SpinHead IMGS/UI/menu/tutorialBook/tutPics/10.png"),
	preload("res://GameFiles/SpinHead IMGS/UI/menu/tutorialBook/tutPics/11.png")
]

var tutText:Array[String] = [
	"Draw a line under the character using your hand/mouse so it doesn't fall.\nDraw the line close to the character so you can react fast when obstacles show up.\nGoing down/up will increase/decrease your speed respectively.",
	"Rolling Back: Even though this is an endless runner, you can roll back if you master the character's momentum.\nThis will help you clear certain obstacles that need a different timing.",
	"Stars: The in-game currency.\nCollect stars and you can buy new characters with them.",
	"Powerups: They'll appear on certain spots on certain buildings.\nThere is a total of 4 powerups, collect them and findout what they do!",
	"Buildings: You can roll on top of any building, just don't hit it from the side or you'll lose.\nConfused? Just follow the stars.\nNote: Buildings with random rooftops can't gameover you, even if hit from the sides.",
	"Hotel: Not the nicest stay I have to say.\nYou can only roll through the hotel halls.\nDon't touch the red walls or you'll lose.",
	"Under Construction Buildings: roll between them and don't touch them at all.",
	"Airships: Don't touch them or you'll lose.",
	"Broken Stage Bars: Don't touch them or you'll lose.",
	"Studio Lights:  Watch out! The ones that look at you fall on you. You can either bait them to fall or roll by fast.\nRollin' down the street, watching lights... Fall by watching you!",
	"Lock-on Missiles: They'll follow you until they destroy you.\nDetonate them by making them hit a surface. You can draw a line to do just that.",
	"Dragons: You can ride on top of them, just don't hit them from beneath or you'll lose.\nConfused? Just follow the stars.",
	"Wind Turbines: You have to go through the blades of the turbine.\nThe blades can't gameover you they can only annoy you.\nHit the building from the side and you'll lose",
	"Flying Timed Bombs: They'll follow you until they destroy you.\nYou can't detonate them. They will automatically explode after 6 seconds if I remember correctly lmao.",
	"Wall-o-Bats: If you know hole in a wall, you know.\ngo through the hole in the bat wall.\nConfused? Just follow the stars."
]

func _ready() -> void:
	visible = false
	readnLearn.text = tutText[0]
	set_process_input(true)

func _process(_delta:float) -> void:
	shady.scale.x = get_node("../../../sizeChange").true_scalex/get_node("../../../sizeChange").true_scaley

func _input(_ev:InputEvent) -> void:
	if (Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_LEFT)) and noSpam:
		if Input.is_key_pressed(KEY_RIGHT):
			_on_forward_btn_pressed()
		else:
			_on_back_btn_pressed()
		noSpam = false
		await get_tree().create_timer(0.1).timeout
		noSpam = true
	if Input.is_key_pressed(KEY_ESCAPE) and visible:
		_on_close_btn_pressed()

func _on_forward_btn_pressed() -> void:
	get_node("PageBg/forwardBTN/AnimationPlayer").play("onClick")
	currPage = min(currPage+1, tutText.size() - 1)
	changePage()

func _on_back_btn_pressed() -> void:
	get_node("PageBg/backBTN/AnimationPlayer").play("onClick")
	currPage = max(currPage-1, 0)
	changePage()

func changePage() -> void:
	currPage = max(0, currPage)
	currPage = min(tutText.size() - 1, currPage)
	bookPics.texture = pics[currPage]
	readnLearn.text = tutText[currPage]
	pageNum.text = str(currPage) + "/" + str(tutText.size() - 1)

func _on_close_btn_pressed() -> void:
	visible = false
	get_tree().paused = false

func getUrS___Right() -> void:
	get_node("PageBg/forwardBTN").position = Vector2(444, -206)
	get_node("PageBg/forwardBTN").scale = Vector2(1, 1)
	get_node("PageBg/backBTN").position = Vector2(-539, -206)
	get_node("PageBg/backBTN").scale = Vector2(1, 1)

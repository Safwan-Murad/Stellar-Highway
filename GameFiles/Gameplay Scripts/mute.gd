extends Button

var notmuted:Resource = preload("res://GameFiles/SpinHead IMGS/UI/menu/mute/notmuted.png")
var muted:Resource = preload("res://GameFiles/SpinHead IMGS/UI/menu/mute/muted.png")
@onready var anim:AnimationPlayer = get_node("AnimationPlayer")
@onready var audio:int = AudioServer.get_bus_index("Master")
var noSpam:bool = true

func _ready() -> void:
	if AudioServer.is_bus_mute(audio):
		self.icon = muted
	else:
		self.icon = notmuted
	set_process_input(true)

func _input(_ev:InputEvent) -> void:
	
	if Input.is_key_pressed(KEY_M) and noSpam:
		_on_pressed()
		noSpam = false
		await get_tree().create_timer(0.25).timeout
		noSpam = true

func _on_pressed() -> void:
	AudioServer.set_bus_mute(audio, not AudioServer.is_bus_mute(audio))
	if AudioServer.is_bus_mute(audio):
		self.icon = muted
	else:
		self.icon = notmuted
	anim.play("onClick")

extends Control
## The interactive controls inside the main-menu Settings panel.
##
## A functional, deliberately-plain set of controls (music volume, haptics, assist draw) wired to
## the [code]Settings[/code] autoload. It's instanced into the Settings popup by settingsMenu.gd.
## Restyle/reposition the nodes in SettingsControls.tscn to taste — the wiring here keys off node
## names, so moving them around in the editor is safe.
##
## Its process_mode is ALWAYS (set in the scene) so the controls still work while the menu is paused.

@onready var music: HSlider = $Center/VBox/MusicSlider
@onready var haptics: CheckButton = $Center/VBox/Haptics
@onready var assist: HSlider = $Center/VBox/AssistSlider

func _ready() -> void:
	# Seed the controls from the saved settings...
	music.value = Settings.music_volume
	haptics.button_pressed = Settings.haptics_on
	assist.value = Settings.draw_offset
	# ...then persist + apply any change the player makes.
	music.value_changed.connect(func(v): Settings.set_value("music_volume", v))
	haptics.toggled.connect(func(on): Settings.set_value("haptics_on", on))
	assist.value_changed.connect(func(v): Settings.set_value("draw_offset", v))

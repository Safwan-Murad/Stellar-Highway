extends Label

var offset:int
var extra:int = 0
var sc:int = 0
var of:int = 0
@onready var player:CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var stars:Label = get_node("../Stars")

func _ready() -> void:
	add_to_group("Score")
	offset = player.position.x

func _process(_delta:float) -> void:
	sc = floor(player.position.x - offset)
	of = floor(extra + stars.stars * 100)
	text = str(sc) + "+" + str(of)

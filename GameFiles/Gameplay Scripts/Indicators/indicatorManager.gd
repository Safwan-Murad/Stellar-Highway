extends Node2D

var AirshipsInd:Resource = preload("res://GameFiles/Sprites/Indicators/AirshipsIndicators.tscn")
var HangingInd:Resource = preload("res://GameFiles/Sprites/Indicators/HangingIndicators.tscn")
var HotelInd:Resource = preload("res://GameFiles/Sprites/Indicators/HotelIndicators.tscn")
var DragonsInd:Resource = preload("res://GameFiles/Sprites/Indicators/DragonsIndicators.tscn")

@onready var parent:Node2D = get_node("../")
@onready var player:CharacterBody2D = get_node("../Player")
var obj:Node2D

func indicateAirships() -> void:
	obj = AirshipsInd.instantiate()
	obj.position.x = player.position.x + (960 * parent.true_scalex/parent.true_scaley)
	obj.position.y = 540
	parent.add_child(obj)

func indicateHSS() -> void:
	obj = HangingInd.instantiate()
	parent.add_child(obj)

func indicateHotel() -> void:
	obj = HotelInd.instantiate()
	obj.position.x = player.position.x + (960 * parent.true_scalex/parent.true_scaley)
	obj.position.y = 540
	parent.add_child(obj)

func indicateDragons(place:int, dr:Node) -> void:
	obj = DragonsInd.instantiate()
	obj.position.x = player.position.x + (960 * parent.true_scalex/parent.true_scaley)
	obj.position.y = 540
	parent.add_child(obj)
	obj.indicateStart(place, dr)

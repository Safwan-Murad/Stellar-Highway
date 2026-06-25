extends Node2D
## Spawns the "danger" warnings that appear ahead of incoming hazards.
##
## Obstacles call these helpers when they spawn; each one drops the right indicator scene a
## fixed distance ahead of the player (scaled by the aspect ratio) so you get a heads-up beep
## and arrow before the hazard arrives. The indicators position and despawn themselves.

var AirshipsInd:Resource = preload("res://GameFiles/Sprites/Indicators/AirshipsIndicators.tscn")
var HangingInd:Resource = preload("res://GameFiles/Sprites/Indicators/HangingIndicators.tscn")
var HotelInd:Resource = preload("res://GameFiles/Sprites/Indicators/HotelIndicators.tscn")
var DragonsInd:Resource = preload("res://GameFiles/Sprites/Indicators/DragonsIndicators.tscn")

@onready var parent:Node2D = get_node("../")
@onready var player:CharacterBody2D = get_node("../Player")
var obj:Node2D  ## Scratch: the indicator instance being spawned.

## Warn that an airships cluster is ahead.
func indicateAirships() -> void:
	obj = AirshipsInd.instantiate()
	obj.position.x = player.position.x + (960 * parent.true_scalex/parent.true_scaley)
	obj.position.y = 540
	parent.add_child(obj)

## Warn that hanging studio stuff (broken stage bars) is ahead.
func indicateHSS() -> void:
	obj = HangingInd.instantiate()
	parent.add_child(obj)

## Warn that a hotel is ahead.
func indicateHotel() -> void:
	obj = HotelInd.instantiate()
	obj.position.x = player.position.x + (960 * parent.true_scalex/parent.true_scaley)
	obj.position.y = 540
	parent.add_child(obj)

## Warn that a dragon is ahead. [param place] is which row (0-2) it occupies so the indicator
## can point at it; [param dr] is the dragon node it should track until passed.
func indicateDragons(place:int, dr:Node) -> void:
	obj = DragonsInd.instantiate()
	obj.position.x = player.position.x + (960 * parent.true_scalex/parent.true_scaley)
	obj.position.y = 540
	parent.add_child(obj)
	obj.indicateStart(place, dr)

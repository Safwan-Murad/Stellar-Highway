extends Node
## Project-wide singleton (autoloaded as [code]Refs[/code]): shared constants and cached lookups.
##
## It exists to remove two recurring sources of friction in the codebase:
## [br]1. [b]Magic numbers[/b] for the screen/world geometry that were copy-pasted across the
##    spawners and guards (the game renders at a fixed 1080p-tall design resolution).
## [br]2. The [b]constant re-searching of the scene tree[/b] — scripts fetch the same handful of
##    nodes by group (or via fragile [code]../../../[/code] paths) every single frame.
##
## The accessors resolve from the same groups the game already uses, then cache the result until
## the node is freed (e.g. on a scene change), at which point they transparently re-resolve. This
## preserves the exact timing semantics of the old [code]get_first_node_in_group()[/code] calls
## (you still get [code]null[/code] before the node exists) while avoiding a tree search per frame.
##
## Autoloads initialise before any scene, so [code]Refs[/code] is safe to reference from other
## scripts' variable initialisers, [code]_ready[/code] and [code]_process[/code].

# --- Screen / world geometry (fixed 1080p-tall design resolution; width flexes per device) ---
const SCREEN_WIDTH := 1920.0   ## Design viewport width, in world units.
const SCREEN_HEIGHT := 1080.0  ## Design viewport height (fixed; the X axis is what stretches).
const DESIGN_ASPECT := SCREEN_WIDTH / SCREEN_HEIGHT  ## 16:9; the reference aspect ratio.
const KILL_Y := 1620.0         ## Y below which a body has fallen off-screen and dies / despawns.

# Cached node references, re-resolved automatically when they become invalid (scene change).
var _player: Node
var _playfield: Node
var _score: Node
var _star_count: Node
var _stars: Node
var _utils: Node
var _powerup_popups: Array
var _camera_shake: Node

## The playable character (group "Player"), or null if there isn't one yet.
func player() -> Node:
	if not is_instance_valid(_player):
		_player = get_tree().get_first_node_in_group("Player")
	return _player

## The gameplay root that owns the aspect-ratio scaling (group "Playfield"), i.e. the
## [code]sizeChange[/code] node. Replaces fragile [code]../../../sizeChange[/code] paths.
func playfield() -> Node:
	if not is_instance_valid(_playfield):
		_playfield = get_tree().get_first_node_in_group("Playfield")
	return _playfield

## The score readout (group "Score"). Note the node's script differs per mode.
func score() -> Node:
	if not is_instance_valid(_score):
		_score = get_tree().get_first_node_in_group("Score")
	return _score

## The in-run star counter (group "StarCnt").
func star_count() -> Node:
	if not is_instance_valid(_star_count):
		_star_count = get_tree().get_first_node_in_group("StarCnt")
	return _star_count

## The star balance label (group "Stars").
func stars() -> Node:
	if not is_instance_valid(_stars):
		_stars = get_tree().get_first_node_in_group("Stars")
	return _stars

## The save/load helper (group "Utils").
func utils() -> Node:
	if not is_instance_valid(_utils):
		_utils = get_tree().get_first_node_in_group("Utils")
	return _utils

## The powerup HUD nodes (group "PowerupPopUps"): [code][0][/code] is the text label and
## [code][1]..[5][/code] are the powerup icons. Re-fetched if the cached list went stale.
func powerup_popups() -> Array:
	if _powerup_popups.is_empty() or not is_instance_valid(_powerup_popups[0]):
		_powerup_popups = get_tree().get_nodes_in_group("PowerupPopUps")
	return _powerup_popups

## Shakes the player camera by [param amount] (0..1 trauma), if the camera exists and the player
## hasn't turned screen shake off. Safe to call from anywhere (e.g. explosions, game over).
func shake(amount: float) -> void:
	if not Settings.shake_on:
		return
	if not is_instance_valid(_camera_shake):
		_camera_shake = get_tree().get_first_node_in_group("CameraShake")
	if _camera_shake:
		_camera_shake.add_trauma(amount)

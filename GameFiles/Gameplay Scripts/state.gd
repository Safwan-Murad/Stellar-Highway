extends Node
## Base "interface" every player state inherits (OnGround, OnAir).
##
## A state reads and writes the host PlayerPhysics each frame. [method step] returns
## the name of the state to switch to, or nothing to stay put.

## Called once when the machine enters this state.
func enter(_host: PlayerPhysics):
	return

## Called every physics frame. Return a state name (e.g. "OnAir") to transition, or
## return nothing to remain in this state.
func step(_host: PlayerPhysics, _delta: float):
	return

## Called once when the machine leaves this state.
func exit(_host: PlayerPhysics):
	return

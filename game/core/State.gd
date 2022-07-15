class_name State
extends Node

var state_machine = null;

#All functions are virtual, this base class shouldn't be used

#Handles input if needed
func handle_input(_event: InputEvent):
	pass;
	
#Regular update
func update(_delta: float):
	pass;
	
#Physics update
func physics_update(_delta: float):
	pass;
	
#Called by the state machine when the state is first entered
func enter():
	pass;
	
#Called by the state machine when the state is about to be exited. Called before 'enter' of the next state
func exit():
	pass;

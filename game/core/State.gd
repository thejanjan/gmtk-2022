class_name State
extends Node2D

var state_machine = null;

func initialize(state_machine):
	self.state_machine = state_machine

#All functions are virtual, this base class shouldn't be used

#Handles input if needed
func handle_input(_event: InputEvent):
	pass;
	
#Regular update
func process(delta: float):
	pass;
	
#Physics update
func physics_process(_delta: float):
	pass;
	
#Called by the state machine when the state is first entered
func enter():
	pass;
	
#Called by the state machine when the state is about to be exited. Called before 'enter' of the next state
func exit():
	pass;

"""
Generic getters
"""

func get_state_machine():
	return self.state_machine

func get_player():
	var player_group = self.get_tree().get_nodes_in_group("Player")
	if player_group:
		return player_group[0]
	return null

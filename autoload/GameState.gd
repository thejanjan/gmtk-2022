extends Node


"""
An autoloaded script that is in charge of
preserving the game's current state (player HP, equipment, etc)
"""


var HP = 6 
var Equipment = {
	Enum.DiceSide.ONE: null,
	Enum.DiceSide.TWO: null,
	Enum.DiceSide.THREE: null,
	Enum.DiceSide.FOUR: null,
	Enum.DiceSide.FIVE: null,
	Enum.DiceSide.SIX: null,
}

func get_player():
	var player_group = self.get_tree().get_nodes_in_group("Player")
	if player_group:
		return player_group[0]
	return null

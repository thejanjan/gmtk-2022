extends Node

signal new_coin(coin_data)
signal coin_flipped(coin_index, item_id)


"""
An autoloaded script that is in charge of
preserving the game's current state (player HP, equipment, etc)
"""


var HP = 6 
var ActiveCoins = []

func get_player():
	var player_group = self.get_tree().get_nodes_in_group("Player")
	if player_group:
		return player_group[0]
	return null

"""
Coin management
"""

func add_coin(coinData):
	"""Spawns a coin."""
	ActiveCoins.append(coinData)
	emit_signal("new_coin", coinData)

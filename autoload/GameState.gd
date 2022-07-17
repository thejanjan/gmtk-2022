extends Node

signal new_coin(coin_data)
signal coin_flipped(coin_index, item_id)

var pos_dict = {};

"""
An autoloaded script that is in charge of
preserving the game's current state (player HP, equipment, etc)
"""

"""
Tile Management
"""

#Checks the given position to see if there is anything there
#Snaps to the nearest tile, then checks a dictionary
#If it is empty, add the position to the dictionary
#If it is used, return an INFINITY VECTOR2
func check_tile(pos : Vector2, type : String) -> Vector2:
	var tileMap = get_node("DungeonGenerator/FloorTileMap");
	pos = tileMap.position_to_tile(pos);
	if pos_dict.has(pos):
		return Vector2.INF;
	else:
		pos_dict[pos] = type;
		return pos;

func get_type(pos : Vector2) -> String:
	return pos_dict[pos];
	
func remove_space(pos : Vector2) -> bool:
	return pos_dict.erase(pos);
	
#Please never use this. It's here if you need it for some god-forsaken reason but PLEASE
func all_spots():
	return pos_dict.keys();



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

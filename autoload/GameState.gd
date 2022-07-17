extends Node

signal new_coin(coin_data)
signal coin_flipped(coin_index, item_id)

var pos_dict = {};

var controls_locked = false

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
	var tileMap = get_tree().get_nodes_in_group("floor_tilemap")[0];
	if tileMap.get_cellv(pos / Vector2(13 * 4, 8 * 4)) == TileMap.INVALID_CELL:
		return Vector2.INF;
	return pos;
	# if pos_dict.has(pos):
		# return Vector2.INF;
	# else:
		# pos_dict[pos] = type;
		# return pos;

func get_type(pos : Vector2) -> String:
	return pos_dict[pos];
	
func remove_space(pos : Vector2) -> bool:
	return pos_dict.erase(pos);
	
#Please never use this. It's here if you need it for some god-forsaken reason but PLEASE
# No promises :)
func all_spots():
	return pos_dict.keys();



var HP = 6 
var cash = 0
var ActiveCoins = []

func get_player():
	var player_group = self.get_tree().get_nodes_in_group("Player")
	if player_group:
		return player_group[0]
	return null
	
func get_world():
	var player_group = self.get_tree().get_nodes_in_group("world")
	if player_group:
		return player_group[0]
	return null
	
func get_dungeon():
	var player_group = self.get_tree().get_nodes_in_group("dungeon")
	if player_group:
		return player_group[0]
	return null

func get_enemy_gen():
	var player_group = self.get_tree().get_nodes_in_group("enemy_gen")
	if player_group:
		return player_group[0]
	return null
	
func goto_next_stage():
	controls_locked = true
	
	# Delete EVERYTHING that isn't necessary.
	var safe = self.get_tree().get_nodes_in_group("no_delete")
	
	var world = get_world()
	var dungeon = get_dungeon()
	var enemy_gen = get_enemy_gen()
	for child in world.get_children() + dungeon.get_children() + enemy_gen.get_children():
		if child in safe:
			continue
		# Kill.
		child.queue_free()
	
	# Clear tilemaps.
	for tilemap in self.get_tree().get_nodes_in_group("tilemap"):
		tilemap.clear()
		
	# New floor.
	dungeon.generate_dungeon()
	
	controls_locked = false

"""
Coin management
"""

func add_coin(coinData):
	"""Spawns a coin."""
	ActiveCoins.append(coinData)
	emit_signal("new_coin", coinData)
	

var flying_text = preload("res://game/gui/FlyingText.tscn")


func make_text(parent: Node, text: String, color: String):
	var txt = flying_text.instance()
	txt.set_text(text)
	txt.set_color(color)
	parent.add_child(txt)
	txt.empower()

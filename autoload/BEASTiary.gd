tool
extends Node

"""
BESAT MODE
"""

# Holds information about enemies

var EnemyMoveDuration = 1.0
var EnemyVisualMoveDuration = 0.25


class _EnemyData:
	
	var packed_scene = null
	var floor_range = [1, null]
	var cost = 1.0
	
	func _init(_floor_range: Array = [1, null],
			       _cost: float = 1.0,
			       scene_path: String = ""):
		floor_range = _floor_range
		cost = _cost
		packed_scene = load(scene_path)
		
	"""
	Getters
	"""
	
	func get_min_floor():
		return self.floor_range[0]
		
	func get_max_floor():
		return self.floor_range[1]
		
	func get_enemy_cost() -> float:
		return self.cost
		
	func get_packed_scene() -> PackedScene:
		return self.packed_scene


var EnemyDB = {
	Enum.EnemyFlavor.PAWN: _EnemyData.new(
		[1, 3],
		2.0,
		"res://game/core/enemies/Pawn.tscn"
	),
	Enum.EnemyFlavor.BATTLESHIP_S: _EnemyData.new(
		[3, null],
		4.0,
		"res://game/core/enemies/Battleship_Small.tscn"
	),
	Enum.EnemyFlavor.BISHOP: _EnemyData.new(
		[2, 4],
		5.0,
		"res://game/core/enemies/Bishop.tscn"
	),
	Enum.EnemyFlavor.GO: _EnemyData.new(
		[4, null],
		8.0,
		"res://game/core/enemies/Go.tscn"
	),
	Enum.EnemyFlavor.KING: _EnemyData.new(
		[2, 3],
		7.0,
		"res://game/core/enemies/King.tscn"
	),
	Enum.EnemyFlavor.KNIGHT: _EnemyData.new(
		[2, 5],
		5.0,
		"res://game/core/enemies/Knight.tscn"
	),
	Enum.EnemyFlavor.QUEEN: _EnemyData.new(
		[3, null],
		40.0,
		"res://game/core/enemies/Queen.tscn"
	),
	# Enum.EnemyFlavor.REVERSI: _EnemyData.new(
	# 	[3, 5],
	# 	5.0,
	# 	"res://game/core/enemies/Reversi.tscn"
	# ),
	Enum.EnemyFlavor.ROOK: _EnemyData.new(
		[2, null],
		6.0,
		"res://game/core/enemies/Rook.tscn"
	),
	Enum.EnemyFlavor.CHECKERS: _EnemyData.new(
		[3, null],
		2.0,
		"res://game/core/enemies/Checkers.tscn"
	)
}


"""
DB accessors
"""

func get_enemy_data(enemy_flavor: int) -> _EnemyData:
	return EnemyDB.get(enemy_flavor)
	
	
func get_random_enemy(dungeon_floor: int, remaining_credits: float) -> _EnemyData:
	# Gets a random enemy valid for the floor with the credits we have left.
	var valid_enemies = []
	
	# Find an valid enemey :) 
	for enemy_data in EnemyDB.values():
		var min_floor = enemy_data.get_min_floor()
		var max_floor = enemy_data.get_max_floor()
		var cost = enemy_data.get_enemy_cost()
		
		# Its pwicey
		if cost > remaining_credits:
			continue
		
		# Is it in range?
		if min_floor != null:
			if dungeon_floor < min_floor:
				continue
		if max_floor != null:
			if dungeon_floor > max_floor:
				continue
		
		#    Ok
		valid_enemies.append(enemy_data)
	
	# Return enemies if we've got em.
	if valid_enemies:
		return Random.choice(valid_enemies)
	else:
		return null

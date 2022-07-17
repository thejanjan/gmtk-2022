extends Node

"""
BESAT MODE
"""


var EnemyMoveDuration = 1.0
var EnemyVisualMoveDuration = 0.25


class _EnemyData:
	
	var enemy_flavor = null
	var packed_scene = null
	var floor_range = [1, null]
	var cost = 1.0
	
	func _init(enemy_flavor: int,
			   floor_range: Array,
			   cost: float,
			   packed_scene: String):
		self.enemy_flavor = enemy_flavor
		self.floor_range = floor_range
		self.cost = cost
		self.packed_scene = load(packed_scene)
		
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


var EnemyDB = [
	_EnemyData.new(
		Enum.EnemyFlavor.PAWN,
		[1, null],
		1.0,
		"res://game/core/enemies/Pawn.tscn"
	),
	_EnemyData.new(
		Enum.EnemyFlavor.BATTLESHIP_S,
		[3, null],
		4.0,
		"res://game/core/enemies/Battleship_Small.tscn"
	),
	_EnemyData.new(
		Enum.EnemyFlavor.BISHOP,
		[1, 3],
		3.0,
		"res://game/core/enemies/Bishop.tscn"
	),
	_EnemyData.new(
		Enum.EnemyFlavor.GO,
		[4, null],
		8.0,
		"res://game/core/enemies/Go.tscn"
	),
	_EnemyData.new(
		Enum.EnemyFlavor.KING,
		[2, 3],
		7.0,
		"res://game/core/enemies/King.tscn"
	),
	_EnemyData.new(
		Enum.EnemyFlavor.KNIGHT,
		[2, 5],
		5.0,
		"res://game/core/enemies/Knight.tscn"
	),
	_EnemyData.new(
		Enum.EnemyFlavor.QUEEN,
		[3, null],
		40.0,
		"res://game/core/enemies/Queen.tscn"
	),
	_EnemyData.new(
		Enum.EnemyFlavor.REVERSI,
		[5, 4],
		5.0,
		"res://game/core/enemies/Reversi.tscn"
	),
	_EnemyData.new(
		Enum.EnemyFlavor.ROOK,
		[2, null],
		6.0,
		"res://game/core/enemies/Rook.tscn"
	),
	_EnemyData.new(
		Enum.EnemyFlavor.CHECKERS,
		[3, null],
		2.0,
		"res://game/core/enemies/Checkers.tscn"
	)
]


"""
DB accessors
"""

func get_enemy_data(enemy_flavor: int) -> _EnemyData:
	return EnemyDB.get(enemy_flavor)
	
	
func get_random_enemy(dungeon_floor: int, remaining_credits: float) -> _EnemyData:
	# Gets a random enemy valid for the floor with the credits we have left.
	var valid_enemies = []
	
	# Find an valid enemey :) 
	for enemy_data in EnemyDB:
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

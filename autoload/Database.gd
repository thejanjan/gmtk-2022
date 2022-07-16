extends Node

"""
An autoload file for lots of important data!
"""

class _ItemData:
	
	var name = 'None'
	var rarity = Enum.ItemRarity.COMMON
	var node = 'res://game/core/equipment/PipDamage.tscn'
	var in_pool = true
	var item_type = null  # assigned by ItemPool
	var resource = null
	
	func _init(name: String, rarity: int, node: String, in_pool: bool = true):
		self.name = name
		self.rarity = rarity
		self.node = node
		self.in_pool = in_pool
		self.resource = load(self.node)
		
	"""
	Getters
	"""
	
	func get_name() -> String:
		return self.name
		
	func get_rarity() -> int:
		return self.rarity
		
	func get_in_pool() -> bool:
		return self.in_pool
		
	func get_item_type() -> int:
		return self.item_type
		
	func load_resource() -> Resource:
		return self.resource
		
	"""
	Setters
	"""
		
	func assign_item_type(item_type):
		self.item_type = item_type


var ItemDB = {
	Enum.ItemType.NIL: _ItemData.new(
		'Nil',
		Enum.ItemRarity.COMMON,
		'res://game/core/equipment/PipDamage.tscn'
	),
	Enum.ItemType.BASIC_DAMAGE: _ItemData.new(
		'Devour',
		Enum.ItemRarity.COMMON,
		'res://game/core/equipment/PipDamage.tscn',
		false
	),
	Enum.ItemType.FAST: _ItemData.new(
		"I'm too scared to actually make the die a ball",
		Enum.ItemRarity.COMMON,
		'res://game/core/equipment/Fast.tscn'
	),
	Enum.ItemType.OIL_SLICK: _ItemData.new(
		"Oil Slick",
		Enum.ItemRarity.COMMON,
		'res://game/core/equipment/OilSlick.tscn'
	)
}


"""
DB accessors
"""

func get_item_data(item_type: int) -> _ItemData:
	return ItemDB.get(item_type)

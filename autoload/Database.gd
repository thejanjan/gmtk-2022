tool
extends Node

"""
An autoload file for lots of important data!
"""

class _ItemData:
	
	var name = "None"
	var description = "None"
	var rarity = Enum.ItemRarity.COMMON
	var node = 'res://game/core/equipment/PipDamage.tscn'
	var in_pool = true
	var item_type = null  # assigned by ItemPool
	var resource = null   # contains the PackedScene for the equipment itself i think
	var texture = null			
	
	func _init(name: String, 
						 rarity: int, 
						 description: String,
						 in_pool: bool = true,
						 node: String = "res://game/core/equipment/PipDamage.tscn",
						 texture_path: String = "res://textures/items/unknown.png"
						 ):
		self.name = name
		self.description = description
		self.rarity = rarity
		self.node = node
		self.in_pool = in_pool
		self.resource = load(self.node)
		self.texture = load(texture_path)
		
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

	func get_description() -> String:
		return self.description

	func get_texture() -> Texture:
		return self.texture
		
	"""
	Setters
	"""
		
	func assign_item_type(item_type):
		self.item_type = item_type


var ItemDB = {
	Enum.ItemType.NIL: _ItemData.new(
		'Nil',
		Enum.ItemRarity.COMMON,
		"if you're reading this, brush your teeth",
		false
	),
	Enum.ItemType.BASIC_DAMAGE: _ItemData.new(
		'Devour',
		Enum.ItemRarity.COMMON,
		"Does damage based on your roll",
		false,
		'res://game/core/equipment/PipDamage.tscn',
		'res://textures/items/DJUNGELSKOG.png'
	),
	Enum.ItemType.FAST: _ItemData.new(
		"I'm too scared to actually make the die a ball",
		Enum.ItemRarity.COMMON,
		"Aerodynamic form improves speed",
		true,
		'res://game/core/equipment/Fast.tscn'
	),
	Enum.ItemType.OIL_SLICK: _ItemData.new(
		"Oil Slick",
		Enum.ItemRarity.COMMON,
		"Party like it's 2010",
		true,
		'res://game/core/equipment/OilSlick.tscn'
	),
	Enum.ItemType.RUBBER_OF_THE_SOUL: _ItemData.new(
		"Rubber of the Soul",
		Enum.ItemRarity.COMMON,
		"Set my heart a-boinging",
		true,
		'res://game/core/equipment/RubberOfTheSoul.tscn'
	),
	Enum.ItemType.STUNT_DOUBLER: _ItemData.new(
		"Stunt Doubler",
		Enum.ItemRarity.COMMON,
		"A Stunt Double adds to your roll!",
		true,
		'res://game/core/equipment/StuntDoubler.tscn'
	),
	Enum.ItemType.BANANA_PEEL: _ItemData.new(
		"Banana Peel",
		Enum.ItemRarity.COMMON,
		"WHOA-",
		true,
		'res://game/core/equipment/BananaPeel.tscn'
	)
}


"""
DB accessors
"""
func get_item_data(item_type: int) -> _ItemData:
	return ItemDB.get(item_type)

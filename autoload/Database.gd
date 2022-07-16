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
						 node: String,
						 description: String = "None",
						 in_pool: bool = true, 
						 texture_path: String = ""
						 ):
		self.name = name
		self.description = description
		self.rarity = rarity
		self.node = node
		self.in_pool = in_pool
		self.resource = load(self.node)
		if texture_path != "":
			self.texture = load(texture_path)
			print(self.texture)
		
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
		'res://game/core/equipment/PipDamage.tscn',
		"Empty"
	),
	Enum.ItemType.BASIC_DAMAGE: _ItemData.new(
		'Devour',
		Enum.ItemRarity.COMMON,
		'res://game/core/equipment/PipDamage.tscn',
		"Does damage based on your roll",
		false,
		'res://textures/items/DJUNGELSKOG.png'
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
	),
	Enum.ItemType.RUBBER_OF_THE_SOUL: _ItemData.new(
		"Rubber of the Soul",
		Enum.ItemRarity.COMMON,
		'res://game/core/equipment/RubberOfTheSoul.tscn'
	),
	Enum.ItemType.STUNT_DOUBLER: _ItemData.new(
		"Stunt Doubler",
		Enum.ItemRarity.COMMON,
		'res://game/core/equipment/StuntDoubler.tscn'
	)
}


"""
DB accessors
"""

func get_item_data(item_type: int) -> _ItemData:
	return ItemDB.get(item_type)

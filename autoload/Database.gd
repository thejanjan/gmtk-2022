tool
extends Node

"""
An autoload file for lots of important data!
"""

class _ItemData:
	
	var name = "None"
	var description = "None"
	var cooldown = 0.0
	var rarity = Enum.ItemRarity.COMMON
	var node = 'res://game/core/equipment/PipDamage.tscn'
	var in_pool = true
	var item_type = null  # assigned by ItemPool
	var resource = null   # contains the PackedScene for the equipment itself i think
	var texture = null			
	var icon_tex = null
	
	func _init(name: String, 
						 rarity: int, 
						 description: String,
						 cooldown: float = 0.0,
						 in_pool: bool = true,
						 node: String = "res://game/core/equipment/PipDamage.tscn",
						 texture_path: String = "res://textures/items/unknown.png",
						 icon_tex_path: String = "res://textures/player/equipment_die.png"
						 ):
		self.name = name
		self.description = description
		self.rarity = rarity
		self.node = node
		self.in_pool = in_pool
		self.cooldown = cooldown
		self.resource = load(self.node)
		self.texture = load(texture_path)
		self.icon_tex = load(icon_tex_path)
		
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
		
	func get_cooldown() -> float:
		return self.cooldown
		
	func get_icon_tex() -> Texture:
		return self.icon_tex
		
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
		1.0,
		false
	),
	Enum.ItemType.BASIC_DAMAGE: _ItemData.new(
		'Takedown',
		Enum.ItemRarity.COMMON,
		"Does damage based on your roll",
		0.6,
		false,
		'res://game/core/equipment/PipDamage.tscn',
		'res://textures/items/item_generic_die.png'

	),
	Enum.ItemType.FAST: _ItemData.new(
		"Endurance",
		Enum.ItemRarity.COMMON,
		"Aerodynamic form improves speed",
		1.0,
		true,
		'res://game/core/equipment/Fast.tscn',
		'res://textures/items/item_weird_die.png',
		'res://textures/items/icons/icon_weird_die.png'
	),
	Enum.ItemType.OIL_SLICK: _ItemData.new(
		"Oil Slick",
		Enum.ItemRarity.SUPERFLUOUS,
		"Party like it's 2010",
		4.0,
		true,
		'res://game/core/equipment/OilSlick.tscn',
		'res://textures/items/item_tar_die.png',
		'res://textures/items/icons/icon_tar_die.png'
	),
	Enum.ItemType.RUBBER_OF_THE_SOUL: _ItemData.new(
		"Rubber of the Soul",
		Enum.ItemRarity.SUPERFLUOUS,
		"Set my heart a-boinging",
		4.0,
		false,
		'res://game/core/equipment/RubberOfTheSoul.tscn',
		'res://textures/items/item_weird_die.png'
	),
	Enum.ItemType.STUNT_DOUBLER: _ItemData.new(
		"Stunt Doubler",
		Enum.ItemRarity.COMMON,
		"Stacked in your favor",
		0.4,
		true,
		'res://game/core/equipment/StuntDoubler.tscn',
		'res://textures/items/item_stack_die.png',
		'res://textures/items/icons/icon_stack_die.png'
	),
	Enum.ItemType.BANANA_PEEL: _ItemData.new(
		"Banana Peel",
		Enum.ItemRarity.COMMON,
		"Whoa-",
		1.0,
		false,
		'res://game/core/equipment/BananaPeel.tscn',
		'res://textures/items/item_banana_die.png',
		'res://textures/items/icons/icon_banana_die.png'
	),
	Enum.ItemType.TRIPLE_DAMAGE: _ItemData.new(
		"Triple Takedown",
		Enum.ItemRarity.RARE,
		"Show them what you've got",
		1.5,
		true,
		'res://game/core/equipment/TripleDamage.tscn',
		'res://textures/items/item_fire_die.png',
		'res://textures/items/icons/icon_fire_die.png'
	),
	Enum.ItemType.CHECKMATE: _ItemData.new(
		"Checkmate",
		Enum.ItemRarity.RARE,
		"Obliterate a chess piece",
		1.0,
		true,
		'res://game/core/equipment/Checkmate.tscn',
		'res://textures/items/item_checkmate_die.png',
		'res://textures/items/icons/icon_checkmate_die.png'
	),
	Enum.ItemType.SHOCKWAVE: _ItemData.new(
		"Shockwave",
		Enum.ItemRarity.COMMON,
		"Hit em all",
		0.4,
		true,
		'res://game/core/equipment/Shockwave.tscn',
		'res://textures/items/item_banana_die.png',
		'res://textures/items/icons/icon_banana_die.png'
	)
}


"""
DB accessors
"""
func get_item_data(item_type: int) -> _ItemData:
	return ItemDB.get(item_type)

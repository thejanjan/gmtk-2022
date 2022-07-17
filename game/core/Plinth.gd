extends Area2D

export(int) var cost = 0
export(Enum.ItemType) var item_type = Enum.ItemType.NIL

onready var item_sprite = $ItemSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	# if an item isn't manually set, pull from the pool
	if item_type == Enum.ItemType.NIL:
		print("Populating Plinth")
		populate()
	else:
		set_item_type(item_type)

func set_item_type(new_item_type: int):
	item_type = new_item_type
	var item_data = Database.get_item_data(item_type)
	if new_item_type != Enum.ItemType.NIL:
		item_sprite.set_texture(item_data.get_texture())

func populate():
	var item_data: Database._ItemData = ItemPool.pop_random_item()
	set_item_type(item_data.get_item_type())
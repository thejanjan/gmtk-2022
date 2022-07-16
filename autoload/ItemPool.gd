extends Node

var Item = load("res://game/core/Item.gd")

class Element:
	var _item_id
	var _weight

	func _init(item_id, weight):
		self._item_id = item_id
		self._weight = weight

var _items = [];
var _rarity_weights = [25, 5, 1];
var _total_weight = 0;

var _item_schema = [];
var _rng = RandomNumberGenerator.new()

func _ready():
	_rng.randomize()
	
	populate()

func add_item(item_id, rarity):
	var weight = rarity_to_weight(rarity)
	_items.append(Element.new(item_id, weight))
	_total_weight += weight;

func remove_item(index):
	var item = _items.pop_at(index)
	_total_weight -= item._weight

func pop_random_item_id():
	var running_weight = _rng.randi_range(0, _total_weight)
	#for item in _items:
	for i in range(_items.size()):
		var item = _items[i]
		if running_weight <= item._weight:
			remove_item(i)
			return item._item_id
		else:
			running_weight -= item._weight
	
	return item_id_when_pool_is_empty()
	
func pop_random_item():
	return _item_schema[pop_random_item_id()]

# Bigger rarity values mean that the item is given less weight in the item pool.
func rarity_to_weight(rarity):
	return _rarity_weights[rarity-1]

func item_id_when_pool_is_empty():
	return Enum.ItemType.NIL
	
func populate():
	var item = Item.new(Enum.ItemType.TEST, 1)
	item._stats._speed = 2.0;
	_item_schema.append(item)
	
	for i in range(_item_schema.size()):
		add_item(i, _item_schema[i]._rarity)

func test_dumb():
	add_item(1, 1)
	add_item(2, 1)
	add_item(3, 1)
	add_item(4, 1)
	add_item(5, 1)
	add_item(6, 2)
	
	for _i in range(8):
		print(pop_random_item_id())

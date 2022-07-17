extends Node

class Element:
	var _item_id
	var _weight

	func _init(item_id, weight):
		self._item_id = item_id
		self._weight = weight

var _weighted_item_datas = [];
var _items = [];
var _total_weight = 0;

var _item_schema = [];
var _rng = RandomNumberGenerator.new()

func _ready():
	_rng.randomize()
	
	populate()

func add_item(item_data, weight):
	_items.append(Element.new(item_data, weight))
	_total_weight += weight;
	for i in range(weight):
		_weighted_item_datas.append(item_data)

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
	return Random.choice(_weighted_item_datas)
	return _item_schema[pop_random_item_id()]

func item_id_when_pool_is_empty():
	return Enum.ItemType.NIL
	
func populate():
	for item_type in Database.ItemDB.keys():
		var item_data = Database.ItemDB.get(item_type)
		item_data.assign_item_type(item_type)
		if item_data.get_in_pool():
			_item_schema.append(item_data)
			add_item(item_data, item_data.get_rarity())

func test_dumb():
	add_item(1, 1)
	add_item(2, 1)
	add_item(3, 1)
	add_item(4, 1)
	add_item(5, 1)
	add_item(6, 2)
	
	for _i in range(8):
		print(pop_random_item_id())

tool
extends Area2D

export(int) var cost = 0
export(Enum.ItemType) var item_type = Enum.ItemType.NIL

onready var _item_sprite = $ItemSprite
onready var _label = $CenterContainer/Label
onready var _label_anim = $CenterContainer/AnimationPlayer

var _player_inside: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# if an item isn't manually set, pull from the pool
	if item_type == Enum.ItemType.NIL:
		print("populating empty plinth from pool")
		var item_data: Database._ItemData = ItemPool.pop_random_item()
		set_item_type(item_data.get_item_type())
	else: 
		set_item_type(item_type)
	update_label()
	
func _unhandled_input(event):
	# player interaction
	if _player_inside and event.is_action_pressed("interact") and not GameState.controls_locked:
		try_purchase()


func set_item_type(new_item_type: int):
	item_type = new_item_type
	var item_data = Database.get_item_data(item_type)
	_item_sprite.set_texture(item_data.get_texture())

func set_cost(new_cost: int):
	cost = new_cost
	update_label()

func update_label() -> void:
		_label.text = "$%d" % cost


func try_purchase() -> void:
	# check if they have enough caaaaaaash
	if GameState.cash >= cost:
		GameState.cash -= cost
		set_cost(0)
		_label_anim.play("purchase_succeed")
		var received_equipment = GameState.get_player().swap_current_equipment(item_type)
		set_item_type(received_equipment)
	else:
		# poor person spotted :(
		_label_anim.play("purchase_fail")


func _on_Plinth_body_entered(_body:Node):
	_player_inside = true


func _on_Plinth_body_exited(_body:Node):
	_player_inside = false

func _on_InteractionArea_body_entered(_body:Node):
	# player interaction:
		try_purchase()

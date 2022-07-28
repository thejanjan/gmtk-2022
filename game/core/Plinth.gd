tool
extends Area2D

export(int) var cost = 0 setget set_cost
export(bool) var infinite_vending = false
export(Enum.ItemType) var item_type = Enum.ItemType.NIL setget set_item_type

onready var _item_sprite = $ItemSprite
onready var _label = $CenterContainer/Label
onready var _label_anim = $CenterContainer/AnimationPlayer
onready var _description = $Description

var _player_inside: bool = false
var ready := false


# Called when the node enters the scene tree for the first time.
func _ready():
	ready = true
	# if an item isn't manually set, pull from the pool
	if not Engine.editor_hint and item_type == Enum.ItemType.NIL:
		print("populating empty plinth from pool")
		var item_data: Database._ItemData = ItemPool.pop_random_item()
		item_type = item_data.get_item_type()
	set_item_type(item_type)
	update_label()


func _unhandled_input(event):
	# player interaction
	if _player_inside and event.is_action_pressed("interact") and not GameState.controls_locked:
		try_purchase()


func set_item_type(new_item_type: int):
	item_type = new_item_type
	var item_data = Database.get_item_data(item_type)
	if ready:
		_item_sprite.set_texture(item_data.get_texture())
		_description.text = item_data.get_description()


func set_cost(new_cost: int):
	cost = new_cost
	update_label()


func update_label() -> void:
	if not ready:
		return
	if cost == 0:
		_label.text = ""
	else:
		_label.text = "$%d" % cost


func try_purchase() -> void:
	var player_pos := GameState.get_player().position as Vector2
	var our_pos = self.position
	var dist = player_pos.distance_to(our_pos)
	if dist > 100:
		# sanity check
		return

	# check if they have enough caaaaaaash
	if GameState.cash >= cost:
		GameState.cash -= cost
		GameState.emit_signal("money_changed", GameState.cash)
		set_cost(0)
		_label_anim.play("purchase_succeed")
		
		var received_equipment = GameState.get_player().swap_current_equipment(item_type)
		if infinite_vending:
			return 
		set_item_type(received_equipment)
	
	else:
		# poor person spotted :(
		_label_anim.play("purchase_fail")


func _on_Plinth_body_entered(_body: Node):
	_player_inside = true
	_description.visible = true


func _on_Plinth_body_exited(_body: Node):
	_player_inside = false
	_description.visible = false


func _on_InteractionArea_body_entered(_body: Node):
	# player interaction:
	try_purchase()

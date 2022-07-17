extends Control


onready var EquipPip = preload("res://game/gui/EquipPip.tscn")
var pips = []
var active_dice = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(6):
		var new_pip = EquipPip.instance()
		add_child(new_pip)
		new_pip.initialize(i, Enum.ItemType.BASIC_DAMAGE)
		new_pip.rect_position += Vector2(0, i * 40)
		pips.append(new_pip)
		
	# Set some hooks for equipment changes.
	var player = GameState.get_player()
	player.connect("on_new_dice", self, "new_equip")
	player.connect("initialize_equips", self, "initialize_equips")
	
	# Equip the starter dice.
	self.pips[active_dice].equip_pip(true)


	# Register plinths in level to listen for 
	register_plinths()
	
	
# TODO: move this plinth registry bullshit somewhere way better
func register_plinths() -> void:
	print("registering plinths")
	var plinths = get_tree().get_nodes_in_group('plinths')
	for plinth in plinths:
		print("registered plinth")
		plinth.connect("body_entered", self, "approach_plinth")
		plinth.connect("body_exited", self, "unapproach_plinth")


func approach_plinth(_node):
	for pip in self.pips:
		pip.approach_plinth()
	
	
func unapproach_plinth(_node):
	for pip in self.pips:
		pip.unapproach_plinth()


func initialize_equips(equip_dict):
	for i in equip_dict.keys():
		var item_id = equip_dict[i]
		self.pips[i].set_item(item_id)


func new_equip(dice_side, item_id):
	# Unequip the old dice.
	pips[active_dice].unequip_pip()
	
	# Equip the new one.
	active_dice = dice_side
	pips[active_dice].equip_pip()
	pips[active_dice].set_item(item_id)

extends Node2D


"""
Manager for coin equipment.
"""

onready var esmScript = preload("res://game/core/player/EquipmentStateMachine.gd")

var active_coins = []
var coin_managers = []


func _ready():
	GameState.connect("new_coin", self, "add_coin")
	GameState.get_player().connect("on_new_dice", self, "on_new_dice")


func add_coin(coinData: DataClasses.CoinData):
	self.active_coins.append(coinData)
	
	# Create a new coin manager.
	var node2d = Node2D.new()
	self.add_child(node2d)
	node2d.set_script(esmScript.new())
	self.coin_managers.append(node2d)


func on_new_dice(side, player_item_id):
	# The player has rolled a new dice.
	# We roll heads or tails per coin.
	for i in self.active_coins.size():
		var coin_data = self.active_coins[i] as DataClasses.CoinData
		var esm = self.coin_managers[i]
		
		# Pick one and roll with it!
		var item_id = coin_data.flip_coin()
		esm.transition(item_id, side)
		GameState.emit_signal("coin_flipped", i, item_id)

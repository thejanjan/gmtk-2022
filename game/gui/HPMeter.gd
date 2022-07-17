extends Control


onready var HPPip = preload("res://game/gui/HPPip.tscn")
var pips = []
var cached_hp = 6


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(9):
		var new_pip = HPPip.instance()
		add_child(new_pip)
		new_pip.initialize(i)
		new_pip.rect_position += Vector2(i * 16, 0)
		pips.append(new_pip)
		if i >= cached_hp:
			new_pip.hide_now()
	GameState.get_player().connect("player_hurt", self, "update_hp_pips")
	
func update_hp_pips():
	var hp = GameState.HP
	print(hp)
	if hp > 9:
		hp = 9
	elif hp < 0:
		hp = 0
	
	if hp > cached_hp:
		# Restore pips.
		for index in range(cached_hp, hp):
			self.pips[index].on_heal()
		
	elif hp < cached_hp:
		# KILL pips.
		for index in range(hp, cached_hp):
			self.pips[index].on_damage()
	
	# Update the cached HP last.
	cached_hp = hp

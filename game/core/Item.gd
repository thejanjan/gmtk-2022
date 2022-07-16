var PlayerStats = load("res://game/core/player/PlayerStats.gd")

var _name;
var _rarity;
var _stats;

func _init(name, rarity):
	_name = name
	_rarity = rarity
	_stats = PlayerStats.new()

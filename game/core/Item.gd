var PlayerStats = load("res://game/core/player/PlayerStats.gd")

var _id;
var _rarity;
var _stats;

func _init(id, rarity):
	_id = id
	_rarity = rarity
	_stats = PlayerStats.new()

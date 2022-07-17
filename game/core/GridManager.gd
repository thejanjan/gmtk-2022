extends Node2D

"""
A manager class in charge of keeping the entire game grid maintained.
"""


var game_grid = [];
export var width = 10;
export var height = 10;


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(width):
		var row = []
		for l in range(height):
			row.append(0)
		self.game_grid.append(row)
	var ship = load("res://game/core/enemies/Battleship_Small.tscn");
	var battleship = ship.instance();
	battleship.init(Vector2(50, 50));
	add_child(battleship);

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

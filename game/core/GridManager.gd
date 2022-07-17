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

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

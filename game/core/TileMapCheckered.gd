extends TileMap


func _ready():
	var cells = get_used_cells()
	for cell in cells:
		var x = cell.x
		var y = cell.y
		var tile_id = (x + y) % 2
		set_cell(x, y, tile_id)

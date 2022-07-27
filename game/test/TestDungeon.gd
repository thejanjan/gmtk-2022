extends YSort

var astar := AStar2D.new()
onready var floor_tile_map := $FloorTileMap as TileMap

func _ready():
	# generate AStar information manually
	# this should be fine for small enough levels, otherwise poke the dungeon 
	# generator and use its generation info to more cleverly generate navigation
	astar.clear()
	var dimensions := floor_tile_map.get_used_rect().size
	# AStar point ids need to be positive, so we transform the index like we're translating the tilemap to all positive coords
	var index_offset := int(dimensions.x/2 + (dimensions.y/2 * dimensions.y))
	print(dimensions, index_offset)
	astar.reserve_space(int(dimensions.x * dimensions.y))

	# First, do one pass to initialize points.
	for vec2 in floor_tile_map.get_used_cells():
		var index = vec2.x + (vec2.y * dimensions.y) + index_offset
		self.astar.add_point(index, vec2)
	
	# Now, do a second pass to form connections.
	for vec2 in floor_tile_map.get_used_cells():
		var index = vec2.x + (vec2.y * dimensions.y) + index_offset
		
		# Check left.
		if vec2.x != 0:
			var adj_vec2 = vec2 + Vector2(-1, 0)
			var adj_cell = floor_tile_map.get_cellv(adj_vec2)
			if adj_cell != TileMap.INVALID_CELL:
				# Form a connection between these two.
				var adj_index = adj_vec2.x + (adj_vec2.y * dimensions.y) + index_offset
				self.astar.connect_points(index, adj_index)
		
		# Check right.
		if vec2.x != (dimensions.x - 1):
			var adj_vec2 = vec2 + Vector2(1, 0)
			var adj_cell = floor_tile_map.get_cellv(adj_vec2)
			if adj_cell != TileMap.INVALID_CELL:
				# Form a connection between these two.
				var adj_index = adj_vec2.x + (adj_vec2.y * dimensions.y) + index_offset
				self.astar.connect_points(index, adj_index)
			
		# Check up.
		if vec2.y != 0:
			var adj_vec2 = vec2 + Vector2(0, -1)
			var adj_cell = floor_tile_map.get_cellv(adj_vec2)
			if adj_cell != TileMap.INVALID_CELL:
				# Form a connection between these two.
				var adj_index = adj_vec2.x + (adj_vec2.y * dimensions.y) + index_offset
				self.astar.connect_points(index, adj_index)
			
		# Check down.
		if vec2.y != (dimensions.y - 1):
			var adj_vec2 = vec2 + Vector2(0, 1)
			var adj_cell = floor_tile_map.get_cellv(adj_vec2)
			if adj_cell != TileMap.INVALID_CELL:
				# Form a connection between these two.
				var adj_index = adj_vec2.x + (adj_vec2.y * dimensions.y) + index_offset
				self.astar.connect_points(index, adj_index)

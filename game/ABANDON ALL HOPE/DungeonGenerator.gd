# Even though a red miasma floods the air, you can still see the sky.
# Even though concrete roars in your ears, you can still feel your own breath.
# Even though peril surrounds you, you can still wear your smile.

# This isn't hell.

extends Node

signal rooms_generated
signal player_spawned
signal enter_floor(dungeon_floor)

onready var Plinth = preload("res://game/core/Plinth.tscn")
onready var KeyPedestal = preload("res://game/core/KeyPedestal.tscn")
onready var Doorway = preload("res://game/core/Doorway.tscn")

# [[proportional chance, resource path, spawn only on edges]]
onready var environmental = [
	[0.4, preload("res://game/core/environmental/Shrubbery.tscn"), false],
	[1.2, preload("res://game/core/environmental/Urn.tscn"), false],
	[0.7, preload("res://game/core/environmental/Column.tscn"), false],
	[0.5, preload("res://game/core/environmental/Streetlamp.tscn"), true],
]

onready var tile_mapper_floor = $FloorTileMap as TileMap
onready var tile_mapper_wall = $WallTileMap as TileMap

export(int) var dungeon_floor = 0

export(int) var dungeon_width = 100
export(int) var dungeon_height = 100

export(int) var number_of_rooms = 10

export(int) var room_min_width = 1
export(int) var room_max_width = 10
export(int) var room_min_height = 1
export(int) var room_max_height = 10

export(int) var number_of_islands = 70

export(int) var island_min_width = 2
export(int) var island_max_width = 4
export(int) var island_min_height = 2
export(int) var island_max_height = 4

export(float) var island_tile_fail_chance = 0.15

export(int) var room_max_color_id = 0

export(int) var hallway_min_thickness = 3
export(int) var hallway_max_thickness = 6

# Set this to true to force room generation to stop.
var stop_generating_rooms = false

var room_coordinates = []
var hallway_coordinates = {}
var position_blocklist = []

var player_start_room = 0

var astar = AStar2D.new()

# Called when the node enters the... oh, you know that already.
func _ready():
	randomize()
	$Music.play()
	generate_dungeon()
	
func adjust_stats(level):
	# Adjusts the stats for a level.
	dungeon_width = 20 + (level * 20)
	dungeon_height = 20 + (level * 20)

	number_of_rooms = 3 + (level * 2)

	room_min_width = 3
	room_max_width = min(5 + level, 9)
	room_min_height = 3
	room_max_height = min(5 + level, 9)
	
	hallway_min_thickness = 4
	hallway_max_thickness = min(5 + level, 8)
	
	room_max_color_id = min((level * 3) - 1, 31)
	
func generate_dungeon():
	dungeon_floor += 1
	adjust_stats(dungeon_floor)
	room_coordinates = []
	hallway_coordinates = {}
	position_blocklist = []
	
	stop_generating_rooms = false
	
	for _i in range(number_of_rooms):
		if stop_generating_rooms == false:
			generate_room()
		
	generate_hallways()
	
	generate_islands()
	
	generate_astar()
	
	generate_wall_tiles()
	
	emit_signal("rooms_generated")
	
	generate_plinths()
	
	generate_key_pedestals()
	
	generate_environmental()
		
	# Place the player in the first room.
	position_player()
	
	emit_signal("player_spawned")
	
	emit_signal("enter_floor", dungeon_floor)
	
	# Start the song.
	update_music()

func generate_room():
	var room_undecided = true
	var room_rect
	var room_width
	var room_height
	
	# Keep looping until the room intersects no other rooms or a max iteration count is passed.
	var iterations = 0
	var iterations_max = 25
	while room_undecided and iterations < iterations_max:
		var room_position = Vector2(Random.randint(0, dungeon_width + 1), Random.randint(0, dungeon_height + 1))
		room_width = Random.randint(room_min_width, room_max_width + 1)
		room_height = Random.randint(room_min_height, room_max_height + 1)
		var room_size = Vector2(room_width, room_height)
		room_rect = Rect2(room_position, room_size)
		
		room_undecided = false
		for other_room_rect in room_coordinates:
			if other_room_rect.intersects(room_rect):
				room_undecided = true
				break
				
		iterations += 1
		
	if iterations == iterations_max:
		stop_generating_rooms = true
	else:
		var color = Random.randint(0, room_max_color_id + 1)
		
		room_coordinates.append(room_rect)
		
		var top_left = get_room_top_left_tilepos(room_coordinates.size() - 1)
		
		for x in range(top_left.x, top_left.x + room_width):
			for y in range(top_left.y, top_left.y + room_height):
				place_room_tile(x, y, color)
			
func generate_hallways():
	var hallway_pairs = prims_algorithm()
	
	#for i in range(get_number_of_generated_rooms() - 1):
	for hallway_pair in hallway_pairs:
		var thickness = Random.randint(hallway_min_thickness, hallway_max_thickness + 1)
		var horizontal_first = (Random.randint(0, 2) == 1)
		generate_hallway(hallway_pair[0], hallway_pair[1], thickness, horizontal_first)
	
func generate_hallway(room_id_start, room_id_end, thickness, horizontal_first):
	var position_start = get_room_center_tilepos(room_id_start)
	var position_end = get_room_center_tilepos(room_id_end)
	var color = Random.randint(0, room_max_color_id + 1)
	var hallways = []
	
	var position_elbow = position_start
	if horizontal_first:
		position_elbow.x = position_end.x
		hallways.append(generate_hallway_horizontal(position_start, position_elbow, thickness, color))
		hallways.append(generate_hallway_vertical(position_elbow, position_end, thickness, color))
	else:
		position_elbow.y = position_end.y
		hallways.append(generate_hallway_vertical(position_start, position_elbow, thickness, color))
		hallways.append(generate_hallway_horizontal(position_elbow, position_end, thickness, color))
	
	# Fill in the elbow.
	var startx = position_elbow.x - thickness/2
	var endx = startx + thickness
	var starty = position_elbow.y - thickness/2
	var endy = starty + thickness
	for x in range(startx, endx):
		for y in range(starty, endy):
			place_hallway_tile(x, y, color)
	
	# Assign the hallways to this room ID pair.
	self.hallway_coordinates[[room_id_start, room_id_end]] = hallways
		
func generate_hallway_horizontal(position_start, position_end, thickness, color):
	var startx = min(position_start.x, position_end.x)
	var endx = max(position_start.x, position_end.x)
	var starty = position_start.y - thickness/2
	var endy = starty + thickness
	for x in range(startx, endx):
		for y in range(starty, endy):
			place_hallway_tile(x, y, color)
	return Rect2(startx, starty, endx - startx, thickness)
			
func generate_hallway_vertical(position_start, position_end, thickness, color):
	var startx = position_start.x - thickness/2
	var endx = startx + thickness
	var starty = min(position_start.y, position_end.y)
	var endy = max(position_start.y, position_end.y)
	for x in range(startx, endx):
		for y in range(starty, endy):
			place_hallway_tile(x, y, color)
	return Rect2(startx, starty, thickness, endy - starty)
			
func generate_wall_tiles():
	# This is efficient!
	for tile in tile_mapper_floor.get_used_cells():
		for vec in [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]:
			if tile_mapper_floor.get_cellv(tile + vec) == TileMap.INVALID_CELL:
				tile_mapper_wall.set_cellv(tile + vec, 0)
				
func generate_astar():
	# Over all floor tiles, generate our a* map.
	self.astar.clear()
	self.astar = AStar2D.new()
	var size = tile_mapper_floor.get_used_rect().size
	self.astar.reserve_space(size.x * size.y)
	
	# First, do one pass to initialize points.
	for vec2 in tile_mapper_floor.get_used_cells():
		var index = vec2.x + (vec2.y * size.y)
		self.astar.add_point(index, vec2)
	
	# Now, do a second pass to form connections.
	for vec2 in tile_mapper_floor.get_used_cells():
		var index = vec2.x + (vec2.y * size.y)
		
		# Check left.
		if vec2.x != 0:
			var adj_vec2 = vec2 + Vector2(-1, 0)
			var adj_cell = tile_mapper_floor.get_cellv(adj_vec2)
			if adj_cell != TileMap.INVALID_CELL:
				# Form a connection between these two.
				var adj_index = adj_vec2.x + (adj_vec2.y * size.y)
				self.astar.connect_points(index, adj_index)
		
		# Check right.
		if vec2.x != (self.dungeon_width - 1):
			var adj_vec2 = vec2 + Vector2(1, 0)
			var adj_cell = tile_mapper_floor.get_cellv(adj_vec2)
			if adj_cell != TileMap.INVALID_CELL:
				# Form a connection between these two.
				var adj_index = adj_vec2.x + (adj_vec2.y * size.y)
				self.astar.connect_points(index, adj_index)
			
		# Check up.
		if vec2.y != 0:
			var adj_vec2 = vec2 + Vector2(0, -1)
			var adj_cell = tile_mapper_floor.get_cellv(adj_vec2)
			if adj_cell != TileMap.INVALID_CELL:
				# Form a connection between these two.
				var adj_index = adj_vec2.x + (adj_vec2.y * size.y)
				self.astar.connect_points(index, adj_index)
			
		# Check down.
		if vec2.y != (self.dungeon_height - 1):
			var adj_vec2 = vec2 + Vector2(0, 1)
			var adj_cell = tile_mapper_floor.get_cellv(adj_vec2)
			if adj_cell != TileMap.INVALID_CELL:
				# Form a connection between these two.
				var adj_index = adj_vec2.x + (adj_vec2.y * size.y)
				self.astar.connect_points(index, adj_index)
		
				
func generate_plinths():
	# PLlinth time baby
	for i in range(min(floor(1.0 + (float(self.dungeon_floor) / 2)), 3)):
		var new_plinth = Plinth.instance()
		add_child(new_plinth)
		var plinth_pos = self.get_random_spawn_pos(true, false)
		new_plinth.translate(plinth_pos * Vector2(13, 8) * 4)
		new_plinth.set_cost(10 * self.dungeon_floor)
		
func generate_key_pedestals():
	for i in range(min(2 + self.dungeon_floor, 25)):
		var new_plinth = KeyPedestal.instance()
		add_child(new_plinth)
		var plinth_pos = self.get_random_spawn_pos(true, false)
		new_plinth.translate(plinth_pos * Vector2(13, 8) * 4)
	var new_plinth = Doorway.instance()
	add_child(new_plinth)
	var plinth_pos = self.get_random_spawn_pos(true, false)
	new_plinth.translate(plinth_pos * Vector2(13, 8) * 4)

# Surround yourself in secrecy... disguise your true intent.
# Convince your friends to join the fun, but oh, do not forget:
# Be careful what you look for; be careful what you see.
# Avert your eyes, or you will blind yourself as well as me.
func generate_environmental():
	# magic numbers
	var average_objects_per_room = 2
	
	# populate environmental chances
	var total = 0
	var environmental_norm = []
	for e in environmental:
		total += e[0]
		environmental_norm.push_back([total, e[1]])
	
	# generate objects
	for i in range(get_number_of_generated_rooms() * average_objects_per_room):
		var choice = rand_range(0, total)
		# no functional programming so I have to go through and find the chosen one
		var new_object_class = null
		var on_edge = false
		for e in environmental:
			new_object_class = e[1]
			on_edge = e[2]
			if e[0] > choice:
				break
		var new_object = new_object_class.instance()
		add_child(new_object)
		var object_pos = self.get_random_spawn_pos(false, true, on_edge) # rooms and hallways
		new_object.translate(object_pos * Vector2(13, 8) * 4)
		# random chance to be facing the other way
		if randf() < 0.5:
			# flip_h if possible
			var sprite = new_object.get_node("Sprite")
			if sprite:
				sprite.flip_h = true
				# adjust hitbox if possible
				var hitbox = new_object.get_node("CollisionShape2D")
				if hitbox:
					hitbox.position.x = -hitbox.position.x

func generate_islands():
	for i in range(number_of_islands):
		var room_position = Vector2(Random.randint(0, dungeon_width + 1), Random.randint(0, dungeon_height + 1))
		var room_width = Random.randint(island_min_width, island_max_width + 1)
		var room_height = Random.randint(island_min_height, island_max_height + 1)
		var room_size = Vector2(room_width, room_height)
		var color = Random.randint(0, room_max_color_id + 1)
		var pick_col = Random.choice([0, 1])
		for x in range(room_position.x, room_position.x + room_width):
			for y in range(room_position.y, room_position.y + room_height):
				if randf() < island_tile_fail_chance:
					continue
				place_floor_tile(x, y, color, pick_col)

func update_music():
	if dungeon_floor == 3:
		$Music.stream = load("res://audio/song_NIRVANA.ogg")
		$Music.play()
	if dungeon_floor == 5:
		$Music.stream = load("res://audio/song_KING.ogg")
		$Music.play()
	
func place_floor_tile(x, y, color, only_col = null):
	var tile = tile_mapper_floor.get_cell(x, y)
	if tile == TileMap.INVALID_CELL:
		# Checkerboard pattern!
		var tile_id = int(x + y) % int(2)
		
		if only_col != null:
			if tile_id != only_col:
				return
		
		tile_id += color * 2
		
		tile_mapper_floor.set_cell(x, y, tile_id)

func place_room_tile(x, y, color):
	place_floor_tile(x, y, color)
	#tile_mapper_floor.set_cell(x, y, 0)

func place_hallway_tile(x, y, color):
	place_floor_tile(x, y, color)
	#tile_mapper_floor.set_cell(x, y, 0)

func get_room_center_tilepos(room_id):
	return room_coordinates[room_id].position
	#var room_rect = room_coordinates[room_id] as Rect2
	#return room_rect.position + (room_rect.size / 2)

func get_room_center(room_id):
	return get_room_center_tilepos(room_id) + Vector2(0.5, 0.5)
	
func get_room_top_left_tilepos(room_id):
	var room_rect = room_coordinates[room_id] as Rect2
	return room_rect.position - room_rect.size/2
	
func get_number_of_generated_rooms():
	return room_coordinates.size()
	
func position_player():
	if get_number_of_generated_rooms() == 0:
		print("tried to position player when no rooms were generated")
	
	var room_center = get_room_center(self.player_start_room)
	var player = GameState.get_player() as Node2D
	if player:
		player.position = room_center * Vector2(13, 8) * 4
	else:
		print("???")
		
func get_random_spawn_pos(in_room: bool = false, in_hallway: bool = false, on_edge: bool = false) -> Vector2:
	"""
	Gets a random spawn position that is safe.
	"""
	assert (in_room or in_hallway)
	
	# Figure out all the rect2s that are safe.
	var valid_rect2s = []
	
	if in_room:
		for i in room_coordinates.size():
			if i == self.player_start_room:
				continue
			valid_rect2s.append(room_coordinates[i])
	if in_hallway:
		for key in hallway_coordinates.keys():
			valid_rect2s.append_array(hallway_coordinates[key])
		
	# Pick a random vector within a rect2.
	var rect2 = null
	var vec2 = null
	
	# Attempt to find a good location.
	var attempts = 0
	while true:
		attempts += 1

		# failsafe
		if attempts > 1000:
			break
			
		# choose a candidate position
		rect2 = Random.choice(valid_rect2s) as Rect2
		if attempts < 10:
			vec2 = Random.point_in_rect2(rect2, 1)
		else:
			vec2 = Random.point_in_rect2(rect2, 0)
		
		# don't be an infinite vector (how???)
		if vec2 == Vector2.INF:
			continue
			
		if on_edge:
			var direction = Random.randint(0, 4)
			var directions = [Vector2.LEFT, Vector2.UP, Vector2.RIGHT, Vector2.DOWN]
			var delta = directions[direction]
			# Seems buggy for some reason.
			#while tile_mapper_floor.get_cellv(vec2 + delta) != TileMap.INVALID_CELL:
			#	vec2 += delta
		
		# don't create an object near to where we already put one
		if attempts <= 200:
			var too_close = false
			for b in position_blocklist:
				# attempts = 1, required_distance = 4
				# attempts = 200, required_distance = 1
				var required_distance = (250-attempts)/50
				if vec2.distance_to(b) < required_distance:
					too_close = true
					break # skip the other for loop checks, we don't need them
			if too_close:
				continue # next while loop spawn attempt
		
		# don't spawn too close to invalid cells
		if attempts < 250:
			var close_to_invalid = false
			for offvec in [Vector2.ZERO, Vector2.LEFT, Vector2.UP, Vector2.RIGHT, Vector2.DOWN]:
				if tile_mapper_floor.get_cellv(vec2 + offvec) == TileMap.INVALID_CELL:
					close_to_invalid = true
					break # skip the other for loop checks, we don't need them
			if close_to_invalid:
				continue # next while loop spawn attempt
		
		break # this is a good spawn location!
	
	# phew!
	# print(attempts)

	# Return our vector.
	position_blocklist.append(vec2)
	return vec2
	

func prims_algorithm():
	var node_pairs = []

	var remaining_nodes = []
	for i in range(0, get_number_of_generated_rooms()):
		remaining_nodes.append(i)
	
	var tree_nodes = []
	
	# Start the tree at node 0.
	var node_0 = remaining_nodes.pop_front()
	tree_nodes.append(node_0)
	
	while remaining_nodes.size() != 0:
		var lowest_cost = 9999999
		var lowest_cost_node_pair = [-1, -1]
		for tree_node in tree_nodes:
			for remaining_node in remaining_nodes:
				var cost = room_coordinates[tree_node].position.distance_squared_to(room_coordinates[remaining_node].position)
				if cost < lowest_cost:
					lowest_cost = cost
					lowest_cost_node_pair = [tree_node, remaining_node]
		
		var tree_node = lowest_cost_node_pair[0]
		if lowest_cost_node_pair[0] != -1:
			tree_nodes.append(tree_node)
			node_pairs.append(lowest_cost_node_pair)
			var remaining_node = lowest_cost_node_pair[1]
			
			for i in range(0, remaining_nodes.size()):
				if remaining_nodes[i] == remaining_node:
					remaining_nodes.pop_at(i)
					break
			#remaining_nodes.remove(remaining_node)
	
	return node_pairs

# Delaunay triangulation brings forth the power of the simplex.
# Do you know what else holds the power of the simplex?
# Yes, that's right.
# Herpes simplex virus.
func triangulate():
	# Speaking of herpes, I ran out of time to program this.
	pass

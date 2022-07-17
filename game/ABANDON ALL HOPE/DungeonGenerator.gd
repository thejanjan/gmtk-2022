# Even though a red miasma floods the air, you can still see the sky.
# Even though concrete roars in your ears, you can still feel your own breath.
# Even though peril surrounds you, you can still wear your smile.

# This isn't hell.

extends Node

signal rooms_generated
signal player_spawned

onready var tile_mapper_floor = $FloorTileMap as TileMap
onready var tile_mapper_wall = $WallTileMap as TileMap

export(int) var dungeon_floor = 1

export(int) var dungeon_width = 100
export(int) var dungeon_height = 100

export(int) var number_of_rooms = 10

export(int) var room_min_width = 1
export(int) var room_max_width = 10
export(int) var room_min_height = 1
export(int) var room_max_height = 10

export(int) var room_max_color_id = 0

export(int) var hallway_min_thickness = 3
export(int) var hallway_max_thickness = 6

var room_coordinates = []
var hallway_coordinates = {}

var position_blocklist = []

var player_start_room = 0

# Called when the node enters the... oh, you know that already.
func _ready():
	randomize()
	generate_dungeon()
	
func generate_dungeon():
	for _i in range(number_of_rooms):
		generate_room()
		
	generate_hallways()
	
	generate_wall_tiles()
	
	emit_signal("rooms_generated")
		
	# Place the player in the first room.
	position_player()
	
	emit_signal("player_spawned")

func generate_room():
	var room_position = Vector2(Random.randint(0, dungeon_width + 1), Random.randint(0, dungeon_height + 1))
	var room_width = Random.randint(room_min_width, room_max_width + 1)
	var room_height = Random.randint(room_min_height, room_max_height + 1)
	
	var color = Random.randint(0, room_max_color_id + 1)
	
	room_coordinates.append(Rect2(room_position, Vector2(room_width, room_height)))

	for i in range(room_width):
		for j in range(room_height):
			var x = room_position.x + i
			var y = room_position.y + j
			place_room_tile(x, y, color)
			
func generate_hallways():
	# TODO: Graph magic.
	for i in range(number_of_rooms - 1):
		var thickness = Random.randint(hallway_min_thickness, hallway_max_thickness + 1)
		var horizontal_first = (Random.randint(0, 2) == 1)
		generate_hallway(i, i + 1, thickness, horizontal_first)
	
func generate_hallway(room_id_start, room_id_end, thickness, horizontal_first):
	var position_start = get_room_center_tilepos(room_id_start)
	var position_end = get_room_center_tilepos(room_id_end)
	var color = Random.randint(0, room_max_color_id + 1)
	var hallways = []
	
	if horizontal_first:
		var position_elbow = position_start
		position_elbow.x = position_end.x
		hallways.append(generate_hallway_horizontal(position_start, position_elbow, thickness, color))
		hallways.append(generate_hallway_vertical(position_elbow, position_end, thickness, color))
	else:
		var position_elbow = position_start
		position_elbow.y = position_end.y
		hallways.append(generate_hallway_vertical(position_start, position_elbow, thickness, color))
		hallways.append(generate_hallway_horizontal(position_elbow, position_end, thickness, color))
	
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
	
func place_floor_tile(x, y, color):
	
	var tile = tile_mapper_floor.get_cell(x, y)
	if tile == TileMap.INVALID_CELL:
		# Checkerboard pattern!
		var tile_id = int(x + y) % int(2)
		tile_id += color * 2
		
		tile_mapper_floor.set_cell(x, y, tile_id)

func place_room_tile(x, y, color):
	place_floor_tile(x, y, color)
	#tile_mapper_floor.set_cell(x, y, 0)

func place_hallway_tile(x, y, color):
	place_floor_tile(x, y, color)
	#tile_mapper_floor.set_cell(x, y, 0)

func get_room_center_tilepos(room_id):
	var room_rect = room_coordinates[room_id] as Rect2
	return room_rect.position + (room_rect.size / 2)

func get_room_center(room_id):
	return get_room_center_tilepos(room_id) + Vector2(0.5, 0.5)
	
func position_player():
	var room_center = get_room_center(self.player_start_room)
	var player = GameState.get_player()
	if player:
		player.translate(room_center * Vector2(13, 8) * 4)
	else:
		print("???")
		
func get_random_spawn_pos(in_room: bool = false, in_hallway: bool = false) -> Vector2:
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
			if self.player_start_room in key:
				continue
			valid_rect2s.append_array(hallway_coordinates[key])
		
	# Pick a random vector within a rect2.
	var rect2 = null
	var vec2 = null
	
	# Don't spawn multiple things in the same spot.
	while true:
		rect2 = Random.choice(valid_rect2s) as Rect2
		vec2 = Random.point_in_rect2(rect2)
		if vec2 in position_blocklist:
			continue
		break
	
	# Return our vector.
	position_blocklist.append(vec2)
	return vec2
	

# Delaunay triangulation brings forth the power of the simplex.
# Do you know what else holds the power of the simplex?
# Yes, that's right.
# Herpes simplex virus.
func triangulate():
	pass


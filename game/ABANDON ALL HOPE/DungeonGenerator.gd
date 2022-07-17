# Even though a red miasma floods the air, you can still see the sky.
# Even though concrete roars in your ears, you can still feel your own breath.
# Even though peril surrounds you, you can still wear your smile.

# This isn't hell.

extends Node

onready var tile_mapper_floor = $FloorTileMap as TileMap
onready var tile_mapper_wall = $WallTileMap as TileMap

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

# Used by the hallway connection system.
var grid_of_occupation = [[]]

# Called when the node enters the... oh, you know that already.
func _ready():
	randomize()
	generate_dungeon()
	
func generate_dungeon():
	for i in range(number_of_rooms):
		generate_room()
		
	generate_hallways()
	
	generate_wall_tiles()
		
	# Place the player in the first room.
	position_player()

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
	for i in range(number_of_rooms-1):
		var thickness = Random.randint(hallway_min_thickness, hallway_max_thickness + 1)
		var horizontal_first = (Random.randint(0, 2) == 1)
		generate_hallway(i, i+1, thickness, horizontal_first)
	
func generate_hallway(room_id_start, room_id_end, thickness, horizontal_first):
	var position_start = room_coordinates[room_id_start].position
	var position_end = room_coordinates[room_id_end].position
	var color = Random.randint(0, room_max_color_id + 1)
	
	if horizontal_first:
		var position_elbow = position_start
		position_elbow.x = position_end.x
		generate_hallway_horizontal(position_start, position_elbow, thickness, color)
		generate_hallway_vertical(position_elbow, position_end, thickness, color)
	else:
		var position_elbow = position_start
		position_elbow.y = position_end.y
		generate_hallway_vertical(position_start, position_elbow, thickness, color)
		generate_hallway_horizontal(position_elbow, position_end, thickness, color)
		
		
func generate_hallway_horizontal(position_start, position_end, thickness, color):
	var startx = min(position_start.x, position_end.x)
	var endx = max(position_start.x, position_end.x)
	for x in range(startx, endx):
		for y in range(position_start.y, position_start.y + thickness):
			place_hallway_tile(x, y, color)
			
func generate_hallway_vertical(position_start, position_end, thickness, color):
	var starty = min(position_start.y, position_end.y)
	var endy = max(position_start.y, position_end.y)
	for x in range(position_start.x, position_start.x + thickness):
		for y in range(starty, endy):
			place_hallway_tile(x, y, color)
			
func generate_wall_tiles():
	# This is efficient!
	for tile in tile_mapper_floor.get_used_cells():
		for vec in [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]:
			if tile_mapper_floor.get_cellv(tile + vec) == TileMap.INVALID_CELL:
				tile_mapper_wall.set_cellv(tile + vec, 0)
	
func place_floor_tile(x, y, color):
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
	
func position_player():
	var room_rect = room_coordinates[0] as Rect2
	var room_center = room_rect.position + (room_rect.size / 2) + Vector2(0.5, 0.5)
	var player = GameState.get_player()
	if player:
		player.translate(room_center * Vector2(13, 8) * 4)
	else:
		print("???")

# Delaunay triangulation brings forth the power of the simplex.
# Do you know what else holds the power of the simplex?
# Yes, that's right.
# Herpes simplex virus.
func triangulate():
	pass

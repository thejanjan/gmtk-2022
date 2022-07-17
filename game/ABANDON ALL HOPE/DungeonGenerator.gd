# Even though a red miasma floods the air, you can still see the sky.
# Even though concrete roars in your ears, you can still feel your own breath.
# Even though peril surrounds you, you can still wear your smile.

# This isn't hell.

extends Node

onready var tile_mapper_floor = $FloorTileMap as TileMap

export(int) var dungeon_width = 100
export(int) var dungeon_height = 100

export(int) var room_min_width = 1
export(int) var room_max_width = 10
export(int) var room_min_height = 1
export(int) var room_max_height = 10

# Used by the hallway connection system.
var grid_of_occupation = [[]]

# Called when the node enters the... oh, you know that already.
func _ready():
	generate_dungeon(10)
	
func generate_dungeon(number_of_rooms):
	for i in range(number_of_rooms):
		generate_room()

func generate_room():
	var room_position = Vector2(Random.randint(0, dungeon_width), Random.randint(0, dungeon_height))
	var room_width = Random.randint(room_min_width, room_max_width)
	var room_height = Random.randint(room_min_height, room_max_height)
	
	for i in range(room_width):
		for j in range(room_height):
			var x = room_position.x + i
			var y = room_position.y + j
			place_floor_tile(x, y)
	
	# TODO: Add room to graph.
	
func place_floor_tile(x, y):
	# Checkerboard pattern!
	var tile_id = int(x + y) % int(2)
	
	tile_mapper_floor.set_cell(x, y, tile_id)

# Delaunay triangulation brings forth the power of the simplex.
# Do you know what else holds the power of the simplex?
# Yes, that's right.
# Herpes simplex virus.
func triangulate():
	pass

extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#Returns any position in the world snapped to the nearest tile
func position_to_tile(pos : Vector2) -> Vector2:
	return to_global(map_to_world(world_to_map(to_local(pos))));
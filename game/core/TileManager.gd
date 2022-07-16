extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#This will snap any position to the grid
#It will snap to the top left corner of the cell!!! NOT THE CENTER!!!!
#Because map_to_world() snaps it there
func getGlobalPos(position : Vector2) -> Vector2:
	return to_global(map_to_world(world_to_map(to_local(position))));

extends Viewport


# Declare member variables here. Examples:
onready var PlayerBase = $PlayerBase
onready var Screen = self.get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Screen.texture = self.get_texture()
	

func get_player_base():
	return PlayerBase

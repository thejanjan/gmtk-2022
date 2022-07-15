extends Viewport


# Declare member variables here. Examples:
onready var screen = self.get_parent().get_node("Screen")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	screen.texture = self.get_texture()
	

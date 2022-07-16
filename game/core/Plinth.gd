extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var cost: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# should only be called when the player enters the collision range
func _on_Plinth_body_entered(_body: Node):
	print("WANNA BU Y SOMETHING")

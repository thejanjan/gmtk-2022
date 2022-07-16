extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$enemytemplate.set_health(10)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$enemytemplate.move_tile(randi() % 8, king)
	

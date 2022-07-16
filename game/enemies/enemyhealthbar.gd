extends Node


# Declare member variables here. Examples:
var health
var maxhealth


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_health(initHealth):
	maxhealth = initHealth
	health = initHealth
	
func lose_health(healthDam):
	health -= healthDam
	if health < 0:
		health = 0
	$healthcolorrect.set_size(Vector2(health / maxhealth * 100, 10))

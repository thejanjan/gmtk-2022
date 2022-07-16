extends RigidBody2D

signal killedenemy
signal UP
signal DOWN
signal LEFT
signal RIGHT
signal DOWNLEFT
signal DOWNRIGHT
signal UPLEFT
signal UPRIGHT

const tile_height = 8;
const tile_width = 13;

# Declare member variables here. Examples:
var maxhealth
var health

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_health(initHealth):
	maxhealth = initHealth
	health = initHealth
	$"health bar".set_health(initHealth)
	
func lose_health(healthDam):
	health -= healthDam
	$"health bar".lose_health(healthDam)
	if health <= 0:
		emit_signal("killedenemy")

func move_tile(direction):
	if direction == 'UP':
		# Add code for movement here
		emit_signal("UP")
	elif direction == 'DOWN':
		# Add code for movement here
		emit_signal("DOWN")
	elif direction == 'LEFT':
		# Add code for movement here
		emit_signal("LEFT")
	elif direction == 'RIGHT':
		# Add code for movement here
		emit_signal("RIGHT")
	elif direction == 'DOWNLEFT':
		# Add code for movement here
		emit_signal("DOWNLEFT")
	elif direction == 'DOWNRIGHT':
		# Add code for movement here
		emit_signal("DOWNRIGHT")
	elif direction == 'UPLEFT':
		# Add code for movement here
		emit_signal("UPLEFT")
	elif direction == 'UPRIGHT':
		# Add code for movement here
		emit_signal("UPRIGHT")

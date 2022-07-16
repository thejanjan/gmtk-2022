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

func move_tile(direction, enemy):
	if direction == 0:
		enemy.translated(Vector2(0,-8))
		emit_signal("UP")
	elif direction == 1:
		enemy.translated(Vector2(0,8))
		emit_signal("DOWN")
	elif direction == 2:
		enemy.translated(Vector2(-13,0))
		emit_signal("LEFT")
	elif direction == 3:
		enemy.translated(Vector2(13,0))
		emit_signal("RIGHT")
	elif direction == 4:
		enemy.translated(Vector2(-13,8))
		emit_signal("DOWNLEFT")
	elif direction == 5:
		enemy.translated(Vector2(13,8))
		emit_signal("DOWNRIGHT")
	elif direction == 6:
		enemy.translated(Vector2(-13,-8))
		emit_signal("UPLEFT")
	elif direction == 7:
		enemy.translated(Vector2(13,-8))
		emit_signal("UPRIGHT")

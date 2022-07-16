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
	#$"health bar".set_health(initHealth)
	
func lose_health(healthDam):
	if (health == null): return;
	health -= healthDam
	#$"health bar".lose_health(healthDam)
	print("Oof, owie, ouch, an enemy got hit");
	if health <= 0:
		self.queue_free();
		emit_signal("killedenemy")

func move_tile(direction, enemy):
	if direction == 0:
		enemy.translated(0, -tile_height);
		emit_signal("UP")
	elif direction == 1:
		enemy.translated(0, tile_height);
		emit_signal("DOWN")
	elif direction == 2:
		enemy.translated(-tile_width, 0);
		emit_signal("LEFT")
	elif direction == 3:
		enemy.translated(tile_width, 0);
		emit_signal("RIGHT")
	elif direction == 4:
		enemy.translated(-tile_width, tile_height);
		emit_signal("DOWNLEFT")
	elif direction == 5:
		enemy.translated(tile_width, tile_height);
		emit_signal("DOWNRIGHT")
	elif direction == 6:
		enemy.translated(-tile_width, -tile_height);
		emit_signal("UPLEFT")
	elif direction == 7:
		enemy.translated(tile_width, -tile_height);
		emit_signal("UPRIGHT")

func find_player(playerx, playery, enemy) -> Vector2:
	playerx = playerx % 13
	playery = playery % 8
	
	var enemyx = enemy.positionx % 13
	var enemyy = enemy.positiony % 8
	
	var tilex = (playerx - enemyx) / 13
	var tiley = (playery - enemyy) / 13
	
	return Vector2(tilex, tiley) # returns number of tiles away from player
	

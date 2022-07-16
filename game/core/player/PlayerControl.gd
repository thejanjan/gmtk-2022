extends KinematicBody2D

const Item = preload("res://game/core/Item.gd")
const PlayerStats = preload("res://game/core/player/PlayerStats.gd")
onready var ConcreteStream: AudioStreamPlayer = $ConcreteStream;

var _stats = PlayerStats.new()
var velocity: Vector2;
# The higher these are, the slower the speed changes to nothing/max speed respectively
var friction = 10;
var acceleration = 90;

onready var PlayerSprite = $PlayerSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	_stats._speed = 900;
	_stats._damage = 1;
	velocity = Vector2(0,0);
	print(ConcreteStream.autoplay);
	pass # Replace with function bitches instead.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Movement
	var h_move = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	var v_move = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	for x in [[0, h_move], [1, v_move]]:
		var i = x[0];
		var move = x[1];
		var movetowardszero = (velocity[i]*(friction-1))/friction
		if move == 0:
			velocity[i] = movetowardszero;
		else:
			var movetowardsmaxspeed = (_stats._speed*move + velocity[i]*(acceleration-1))/acceleration;
			if abs(movetowardsmaxspeed-(_stats._speed*move)) < abs(movetowardszero-(_stats._speed*move)):
				velocity[i] = movetowardsmaxspeed;
			else:
				velocity[i] = movetowardszero;
	
	# Concrete
	var totalspeed = abs(velocity[0] + velocity[1]);
	if totalspeed <= 1:
		ConcreteStream.volume_db = -80;
		ConcreteStream.playing = false;
	else:
		var minvol = -20;			
		var maxvol = 20;			
		ConcreteStream.volume_db = minvol + (abs(minvol)+abs(maxvol)) * min(_stats._speed, abs(velocity[0] + velocity[1])) / _stats._speed;
		if not ConcreteStream.playing:
			ConcreteStream.playing = true;

	velocity = move_and_slide(velocity)
	for i in get_slide_count():
			var collision = get_slide_collision(i)
			print("I collided with ", collision.collider.name)
	# self.translate()

func apply_item(item):
	_stats._speed += item._stats._speed
	_stats._damage += item._stats._damage


func get_player_sprite():
	return PlayerSprite

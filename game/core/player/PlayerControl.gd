extends KinematicBody2D

const Item = preload("res://game/core/Item.gd")
const PlayerStats = preload("res://game/core/player/PlayerStats.gd")
onready var ConcreteStream: AudioStreamPlayer = $ConcreteStream;
var concrete_volume = -80

var _stats = PlayerStats.new()
var velocity: Vector2;
# The higher these are, the slower the speed changes to nothing/max speed respectively
var friction = 3;
var acceleration = 6;

var jumping = false;

var last_veloc = Vector2(0.0, 0.0);
var last_accel = Vector2(0.0, 0.0);

onready var PlayerSprite = $PlayerSprite
onready var PlayerState = $State/StateMachine

var SideEquipment = {
	Enum.DiceSide.ONE : "PipDamage",
	Enum.DiceSide.TWO : "PipDamage",
	Enum.DiceSide.THREE : "PipDamage",
	Enum.DiceSide.FOUR : "PipDamage",
	Enum.DiceSide.FIVE : "PipDamage",
	Enum.DiceSide.SIX : "PipDamage"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	_stats._speed = 200;
	_stats._damage = 1;
	PlayerState.transition("PipDamage");
	velocity = Vector2(0,0);
	self.get_rigid_body().connect("jump_start", self, "on_jump")
	self.get_rigid_body().connect("jump_end", self, "on_jump_end")
	
	pass # Replace with function bitches instead.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Movement
	var h_move = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	var v_move = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	for x in [[0, h_move], [1, v_move]]: # Equivalent to "for i, move in enumerate([h_move, v_move])"
		var i = x[0];
		var move = x[1];
		var movetowardszero = (velocity[i]*(friction-1))/friction # Averages out friction-1 copies of the speed and 0
		if move == 0:
			velocity[i] = movetowardszero;
		else:
			var movetowardsmaxspeed = (_stats._speed*move + velocity[i]*(acceleration-1))/acceleration; # Averages out acceleration-1 copies of the speed and max speed
			if abs(movetowardsmaxspeed-(_stats._speed*move)) < abs(movetowardszero-(_stats._speed*move)):
				velocity[i] = movetowardsmaxspeed;
			else:
				velocity[i] = movetowardszero;
	
	# Normalize
	var totalspeed = pow(pow(abs(velocity[0]),2) + pow(abs(velocity[1]),2), 0.5);
	if totalspeed > _stats._speed:
		for i in range(2):
			velocity[i] *= _stats._speed/totalspeed
		totalspeed = pow(pow(abs(velocity[0]),2) + pow(abs(velocity[1]),2), 0.5);
	print(totalspeed)
	
	# Concrete
	# TODO : make a custom audiostreamplayer that does this for us
	if totalspeed <= 1 or jumping:
		concrete_volume -= 4;
		ConcreteStream.volume_db = concrete_volume;
		if concrete_volume < -40:
			concrete_volume = -40
			ConcreteStream.playing = false;
	else:
		var minvol = -20;			
		var maxvol = 0;			
		var target_volume = minvol + (abs(minvol)+abs(maxvol)) * min(_stats._speed, totalspeed) / _stats._speed;
		concrete_volume += 8
		if concrete_volume > target_volume:
			concrete_volume = target_volume
		ConcreteStream.volume_db = concrete_volume
		if not ConcreteStream.playing:
			ConcreteStream.playing = true;

				
	# Calculate our acceleration.
	velocity = move_and_slide(velocity)
	var acceleration = velocity - last_veloc
	last_veloc = velocity
	_handle_acceleration(acceleration)
	
	
	for i in get_slide_count():
			var collision = get_slide_collision(i)
			# print("I collided with ", collision.collider.name)
	# self.translate()

func apply_item(item):
	_stats._speed += item._stats._speed
	_stats._damage += item._stats._damage
	
	
func _handle_acceleration(accel: Vector2):
	"""Handles acceleration."""
	var rigid_body = self.get_rigid_body()
	# rigid_body.add_force(Vector3(accel.x, 0, accel.y), Vector3.UP)
	rigid_body.handle_speed(velocity)


func get_player_sprite():
	return PlayerSprite
	
	
func get_rigid_body():
	return get_player_sprite().get_player_viewport().get_player_base().get_dice_model()
	
"""
Jump connections
"""

func on_jump():
	print('on_jump')
	jumping = true
	
func on_jump_end():
	print('on_jump_end')
	jumping = false

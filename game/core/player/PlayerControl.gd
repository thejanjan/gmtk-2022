extends KinematicBody2D

signal on_new_dice(dice_side)
signal initialize_equips(equip_dict)
signal pip_stacks_updated

const PlayerStats = preload("res://game/core/player/PlayerStats.gd")
onready var ConcreteStream: AudioStreamPlayer = $ConcreteStream;
var concrete_volume = -80

var _stats = PlayerStats.new()
var velocity: Vector2;

var jumping = false;

var last_veloc = Vector2(0.0, 0.0);
var last_accel = Vector2(0.0, 0.0);

onready var PlayerSprite = $PlayerSprite
onready var ESM = $EquipmentStateMachine

var SideEquipment = {
	Enum.DiceSide.ONE : Enum.ItemType.BASIC_DAMAGE,
	Enum.DiceSide.TWO : Enum.ItemType.STUNT_DOUBLER,
	Enum.DiceSide.THREE : Enum.ItemType.STUNT_DOUBLER,
	Enum.DiceSide.FOUR : Enum.ItemType.STUNT_DOUBLER,
	Enum.DiceSide.FIVE : Enum.ItemType.STUNT_DOUBLER,
	Enum.DiceSide.SIX : Enum.ItemType.STUNT_DOUBLER
}

# Called when the node enters the scene tree for the first time.
func _ready():
	print("New")
	_stats._speed = 300;
	_stats._damage = 1;
	_stats._friction = 3;
	_stats._acceleration = 6;
	velocity = Vector2(0,0);
	#ESM.transition("PipDamage");
	self.get_rigid_body().connect("jump_start", self, "on_jump")
	self.get_rigid_body().connect("jump_end", self, "on_jump_end")
	self.get_rigid_body().connect("side_swapped", self, "on_new_dice")
	self.connect("pip_stacks_updated", self, "pip_stacks_updated")
	self.on_new_dice(self.get_rigid_body().get_active_pip())
	emit_signal("initialize_equips", self.SideEquipment)
	pass # Replace with function bitches instead.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Movement
	var h_move = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	var v_move = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	for x in [[0, h_move], [1, v_move]]: # Equivalent to "for i, move in enumerate([h_move, v_move])"
		var i = x[0];
		var move = x[1];
		var movetowardszero = (velocity[i]*(_stats._friction-1))/_stats._friction # Averages out friction-1 copies of the speed and 0
		if move == 0:
			velocity[i] = movetowardszero;
		else:
			var movetowardsmaxspeed = (_stats._speed*move + velocity[i]*(_stats._acceleration-1))/_stats._acceleration; # Averages out acceleration-1 copies of the speed and max speed
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

	# Slide or bounce
	if _stats._bounciness <= 1:
		velocity = move_and_slide(velocity)
	else:
		var col = move_and_collide(velocity)
		if col != null:
			velocity = velocity.bounce(col.normal)
			velocity.x *= (_stats._bounciness/100.0)
			velocity.y *= (_stats._bounciness/100.0)
	
	# Calculate our acceleration.
	var acceleration = velocity - last_veloc
	last_veloc = velocity
	_handle_acceleration(acceleration)
	
	
	for i in get_slide_count():
			var collision = get_slide_collision(i)
			# print("I collided with ", collision.collider.name)
	# self.translate()
	
	
func _handle_acceleration(accel: Vector2):
	"""Handles acceleration."""
	var rigid_body = self.get_rigid_body()
	# rigid_body.add_force(Vector3(accel.x, 0, accel.y), Vector3.UP)
	rigid_body.handle_speed(velocity)

"""
Useful getters
"""

func get_active_pip():
	return self.get_rigid_body().get_active_pip();

func get_player_sprite():
	return PlayerSprite
	
func get_rigid_body():
	# bruh
	return get_player_sprite().get_player_viewport().get_player_base().get_dice_model()
	
"""
Jump connections
"""

func on_jump():
	jumping = true
	
func on_jump_end():
	jumping = false

"""
Listen for a new dice side
"""

func on_new_dice(side):
	var item_id = SideEquipment.get(side)
	self.ESM.transition(item_id, side)
	emit_signal("on_new_dice", side, item_id)

func pip_stacks_updated(pip_count: int):
	self.get_rigid_body().set_pip_bonus_count(pip_count)

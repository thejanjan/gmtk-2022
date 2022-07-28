extends KinematicBody2D

signal on_new_dice(dice_side)
signal initialize_equips(equip_dict)
signal pip_stacks_updated
signal player_hurt

const PlayerStats = preload("res://game/core/player/PlayerStats.gd")
const EnemyBase = preload("res://game/base/EnemyBase.gd")
onready var ActiveMoveSound: AudioStreamPlayer = $ConcreteStream;
var concrete_volume = -80

var _stats = PlayerStats.new()
var velocity: Vector2;

var jumping = false;

var last_veloc = Vector2(0.0, 0.0);
var last_accel = Vector2(0.0, 0.0);

onready var PlayerSprite = $PlayerSprite
onready var ESM = $EquipmentStateMachine
onready var InvincibilityTimer = $InvincibilityTimer
onready var SpriteAnimator = $AnimationPlayer

var SideEquipment = {
	Enum.DiceSide.ONE : Enum.ItemType.BASIC_DAMAGE,
	Enum.DiceSide.TWO : Enum.ItemType.BASIC_DAMAGE,
	Enum.DiceSide.THREE : Enum.ItemType.BASIC_DAMAGE,
	Enum.DiceSide.FOUR : Enum.ItemType.BASIC_DAMAGE,
	Enum.DiceSide.FIVE : Enum.ItemType.BASIC_DAMAGE,
	Enum.DiceSide.SIX : Enum.ItemType.BASIC_DAMAGE
}

# Called when the node enters the scene tree for the first time.
func _ready():
	print("New")
	_stats._speed = 500;
	_stats._damage = 1;
	_stats._friction = 3;
	_stats._acceleration = 6;
	velocity = Vector2(0,0);
	#ESM.transition("PipDamage");
	self.get_rigid_body().connect("jump_start", self, "on_jump")
	self.get_rigid_body().connect("jump_end", self, "on_jump_end")
	self.get_rigid_body().connect("side_swapped", self, "on_new_dice")
	self.connect("pip_stacks_updated", self, "pip_stacks_updated")
	# self.on_new_dice(self.get_rigid_body().get_active_pip())
	emit_signal("initialize_equips", self.SideEquipment)
	pass # Replace with function bitches instead.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Movement
	var h_move = 0
	var v_move = 0
	if not GameState.controls_locked:
		h_move = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
		v_move = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
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
		ActiveMoveSound.volume_db = concrete_volume;
		if concrete_volume < -40:
			concrete_volume = -40
			ActiveMoveSound.playing = false;
	else:
		var minvol = -20;			
		var maxvol = 0;			
		var target_volume = minvol + (abs(minvol)+abs(maxvol)) * min(_stats._speed, totalspeed) / _stats._speed;
		concrete_volume += 8
		if concrete_volume > target_volume:
			concrete_volume = target_volume
		ActiveMoveSound.volume_db = concrete_volume
		if not ActiveMoveSound.playing:
			ActiveMoveSound.playing = true;

	# Slide or bounce
	if _stats._bounciness <= 1:
		velocity = move_and_slide(velocity, Vector2.ZERO, false, 4, .785398, false)
	else:
		var col = move_and_collide(velocity, false)
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
		# handle collision with objects
		if collision.collider.has_method("handle_player_collision"):
			collision.collider.handle_player_collision(collision)
		# active pieces of equipment, like oil slick, may change collision rules.
		# rules should be mutated.
		var collision_rules = {
			"take_damage": true
		}
		var current_equipment = get_active_equipment()
		if current_equipment and current_equipment.has_method("handle_player_collision"):
			current_equipment.handle_player_collision(collision_rules)
		# handle collision and damage with enemies
		if collision.collider is EnemyBase:
			if InvincibilityTimer.time_left == 0 and collision.collider.prickly and collision_rules.take_damage:
				# yeowch! take damage and start the invuln timer
				SpriteAnimator.play("hurt")
				GameState.make_text(self, "@!#?@!", "f21")
				GameState.HP -= 1
				InvincibilityTimer.start()
				$Hurt.play()
				emit_signal("player_hurt")
				
				if GameState.HP <= 0:
					GameState.reset_variables()
					get_tree().reload_current_scene()

func _handle_acceleration(accel: Vector2):
	"""Handles acceleration."""
	var rigid_body = self.get_rigid_body()
	# rigid_body.add_force(Vector3(accel.x, 0, accel.y), Vector3.UP)
	rigid_body.handle_speed(velocity)
	
func change_audio_to(node_name: String):
	"""Changes the trailing audio."""
	ActiveMoveSound.playing = false
	ActiveMoveSound = self.find_node(node_name)

"""
Useful getters
"""

func get_active_pip():
	return self.get_rigid_body().get_active_pip();
	
func get_active_equipment_data():
	var item_id = self.SideEquipment.get(get_active_pip())
	var item_data = Database.get_item_data(item_id)
	return item_data

# get it from the state machine. can be null if you haven't rolled yet, so watch out!
func get_active_equipment():
	return ESM.state

func get_player_sprite():
	return PlayerSprite
	
func get_rigid_body():
	# bruh
	return get_player_sprite().get_player_viewport().get_player_base().get_dice_model()
	
func get_position():
	return self.position;

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

"""
Inventory managment
"""
# Takes a new item ID and equips it in the given side
func swap_equipment(side, item_id):
	var old_equipment = SideEquipment[side]
	SideEquipment[side] = item_id
	emit_signal("initialize_equips", SideEquipment)
	
	return old_equipment

# Swaps the active equipment
func swap_current_equipment(item_id):
	var active_pip = get_active_pip()
	return swap_equipment(active_pip, item_id)

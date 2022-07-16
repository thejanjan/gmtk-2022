extends RigidBody

const JUMP_VELOCITY = 20
var jumping = -10;
var in_jump = false;
var current_speed = Vector2(0, 0)

signal jump_start;
signal jump_end;
signal side_swapped(side);

const positional_transforms = {
	Enum.DiceSide.ONE:   Quat(Vector3(0, 0, 0)),
	Enum.DiceSide.TWO:   Quat(Vector3(0, 0, -PI / 2)),
	Enum.DiceSide.THREE: Quat(Vector3(-PI / 2, 0, 0)),
	Enum.DiceSide.FOUR:  Quat(Vector3(PI / 2, 0, 0)),
	Enum.DiceSide.FIVE:  Quat(Vector3(0, 0, PI / 2)),
	Enum.DiceSide.SIX:   Quat(Vector3(0, 0, PI)),
}

onready var tween = $Tween
onready var DiceModel = $Icosphere
onready var dice_color = DiceModel.get_surface_material(0).get_albedo()
onready var pip_color = DiceModel.get_surface_material(1).get_albedo()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_axis_lock(PhysicsServer.BODY_AXIS_LINEAR_X + PhysicsServer.BODY_AXIS_LINEAR_Z, true)
	self.tween_pip_color(
		dice_color,
		pip_color,
		0.5
	)


func _physics_process(delta):
	if self.translation.y <= 0 and jumping < 0:
		if in_jump:
			emit_signal("jump_end")
			in_jump = false
		var jump_attempt = Input.is_action_pressed("move_roll")
		if jump_attempt:
			self.apply_impulse(Vector3(0, 0, 0), Vector3(0, JUMP_VELOCITY, 0))
			jumping = 20
			in_jump = true
			emit_signal("jump_start")
	if jumping == 18 and self.translation.y <= 0:
		# Our jump failed.
		jumping = -1
	jumping -= 1
	if jumping == 1:
		self._do_spin()


func get_active_pip():
	"""
	Return the pip on the top of the dice.
	Since this is based on the DiceSide enum,
	the resulting value is 0-5 instead of 1-6.
	"""
	var best_angle = 1000
	var best_pip = 0
	var our_quat = DiceModel.transform.basis.get_rotation_quat().get_euler()
	our_quat.y = 0
	our_quat = Quat(our_quat)
	for dice_side in self.positional_transforms.keys():
		var quat = self.positional_transforms[dice_side]
		var this_distance = our_quat.angle_to(quat)
		if this_distance < best_angle:
			best_angle = this_distance
			best_pip = dice_side
	return best_pip

"""
Handle our current speed
"""

func handle_speed(speed: Vector2):
	"""Handles rotating the dice depending on our current speed."""
	current_speed = speed
	var current_angle = speed.angle()  # in radians
	var our_quat = DiceModel.transform.basis.get_rotation_quat()
	var goal_quat = our_quat
	if speed.length() > 0.1:
		goal_quat = our_quat.get_euler()
		goal_quat.y = -current_angle  # 180 * (current_angle / PI)
		goal_quat = Quat(goal_quat)
	
	# Schlorp schlorp schlorp
	DiceModel.transform = our_quat.slerp(goal_quat, 0.1)

"""
Do Spin!!
"""

func get_valid_dice_sides() -> Array:
	var ret_list = [
		Enum.DiceSide.ONE,
		Enum.DiceSide.TWO,
		Enum.DiceSide.THREE,
		Enum.DiceSide.FOUR,
		Enum.DiceSide.FIVE,
		Enum.DiceSide.SIX,
	]
	ret_list.erase(self.get_active_pip())
	return ret_list

func _do_spin():
	# We gotta pick a side and then do it.
	var dice_side = Random.choice(self.get_valid_dice_sides())
	emit_signal("side_swapped", dice_side)
	var goal_quat = self.positional_transforms[dice_side]
	goal_quat = goal_quat.get_euler()
	goal_quat.y = DiceModel.transform.basis.get_rotation_quat().y
	goal_quat = Quat(goal_quat)
	
	# Begin lerping to this rotation quat.
	tween.interpolate_method(
		self, "_lerp_rotation", DiceModel.transform, Transform(goal_quat, DiceModel.translation),
		0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT
	)
	tween.start()
	
func _lerp_rotation(new_transform):
	DiceModel.transform = new_transform
	

"""
Handy scripts for the pip transitions
"""


func revert_pip_color():
	set_pip_color(self.base_color)


func set_pip_color(color: Color):
	"""Sets the pip color of the dice."""
	DiceModel.get_surface_material(1).set_albedo(color)


func tween_pip_color(color_a: Color, color_b: Color, duration: float = 1.0):
	tween.interpolate_property(
		self.DiceModel.get_surface_material(1),
		"albedo_color",
		color_a, color_b,
		duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT 
	)
	tween.start()

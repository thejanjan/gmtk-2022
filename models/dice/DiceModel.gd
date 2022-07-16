extends RigidBody

const JUMP_VELOCITY = 20
var jumping = 0;

const positional_transforms = {
	Enum.DiceSide.ONE:   Quat(Vector3(0, 0, 0)),
	Enum.DiceSide.TWO:   Quat(Vector3(0, 0, -PI / 2)),
	Enum.DiceSide.THREE: Quat(Vector3(-PI / 2, 0, 0)),
	Enum.DiceSide.FOUR:  Quat(Vector3(PI / 2, 0, 0)),
	Enum.DiceSide.FIVE:  Quat(Vector3(0, 0, PI / 2)),
	Enum.DiceSide.SIX:   Quat(Vector3(0, 0, PI)),
}

onready var DiceModel = $Icosphere

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_axis_lock(PhysicsServer.BODY_AXIS_LINEAR_X + PhysicsServer.BODY_AXIS_LINEAR_Z, true)


func _physics_process(delta):
	var jump_attempt = Input.is_action_pressed("move_roll")
	if jump_attempt and self.translation.y < -0.045 and jumping < 0:
		self.apply_impulse(Vector3(0, 0, 0), Vector3(0, JUMP_VELOCITY, 0))
		jumping = 10
	jumping -= 1


func _get_active_pip():
	"""
	Return the pip on the top of the dice.
	Since this is based on the DiceSide enum,
	the resulting value is 0-5 instead of 1-6.
	"""
	var best_angle = 1000
	var best_pip = 0
	var our_quat = self.transform.basis.get_rotation_quat().get_euler()
	our_quat.y = 0
	our_quat = Quat(our_quat)
	for dice_side in self.positional_transforms.keys():
		var quat = self.positional_transforms[dice_side]
		var this_distance = our_quat.angle_to(quat)
		if this_distance < best_angle:
			best_angle = this_distance
			best_pip = dice_side
	return best_pip

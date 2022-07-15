extends RigidBody

const JUMP_VELOCITY = 20
var jumping = 0;

const positional_transforms = {
	Enum.DiceSide.ONE:   Basis(Vector3(0, 0, 0)),
	Enum.DiceSide.TWO:   Basis(Vector3(0, 0, -PI / 2)),
	Enum.DiceSide.THREE: Basis(Vector3(-PI / 2, 0, 0)),
	Enum.DiceSide.FOUR:  Basis(Vector3(PI / 2, 0, 0)),
	Enum.DiceSide.FIVE:  Basis(Vector3(0, 0, PI / 2)),
	Enum.DiceSide.SIX:   Basis(Vector3(0, 0, PI))
}

export var current_side = Enum.DiceSide.ONE setget set_dice_side

onready var DiceModel = $Icosphere

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_dice_side(self.current_side)
	self.set_axis_lock(PhysicsServer.BODY_AXIS_LINEAR_X + PhysicsServer.BODY_AXIS_LINEAR_Z, true)


func set_dice_side(side):
	self.transform.basis = positional_transforms.get(side)


func _physics_process(delta):
	var jump_attempt = Input.is_action_pressed("move_roll")
	if jump_attempt and self.translation.y < -0.045 and jumping < 0:
		self.apply_impulse(Vector3(0, 0, 0), Vector3(0, JUMP_VELOCITY, 0))
		jumping = 10
	jumping -= 1

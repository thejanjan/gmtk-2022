extends KinematicBody


const JUMP_VELOCITY = 8.5

var movement_dir = Vector3()
var linear_velocity = Vector3()
var jumping = false
var prev_shoot = false
var shoot_blend = 0

onready var gravity = Vector3(0, 0, 5)

const positional_transforms = {
	Enum.DiceSide.ONE:   Basis(Vector3(0, 0, 0)),
	Enum.DiceSide.TWO:   Basis(Vector3(0, 0, -PI / 2)),
	Enum.DiceSide.THREE: Basis(Vector3(-PI / 2, 0, 0)),
	Enum.DiceSide.FOUR:  Basis(Vector3(PI / 2, 0, 0)),
	Enum.DiceSide.FIVE:  Basis(Vector3(0, 0, PI / 2)),
	Enum.DiceSide.SIX:   Basis(Vector3(0, 0, PI))
}


export var current_side = Enum.DiceSide.ONE setget set_dice_side


# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_dice_side(self.current_side)


func set_dice_side(side):
	self.transform.basis = positional_transforms.get(side)
	
	
func _physics_process(delta):
	linear_velocity += gravity * delta

	var vv = linear_velocity.y # Vertical velocity.
	var hv = Vector3(linear_velocity.x, 0, linear_velocity.z) # Horizontal velocity.

	var hdir = hv.normalized() # Horizontal direction.
	var hspeed = hv.length() # Horizontal speed.

	# Player input.
	var jump_attempt = Input.is_action_pressed("move_roll")

	if not jumping and jump_attempt:
		print("WOW")
		vv = JUMP_VELOCITY
		jumping = true
	linear_velocity = hv + Vector3.UP * vv
	linear_velocity = move_and_slide(linear_velocity, -gravity.normalized())
	if self.translation.z < 0:
		jumping = false
		self.translation.z = 0

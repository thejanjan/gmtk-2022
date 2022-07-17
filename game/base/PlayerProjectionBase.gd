extends Spatial


onready var DropShadow = $DropShadow
onready var DiceModel = $DiceModel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

func _physics_process(delta):
	# Place the drop shadow.
	var angle = DiceModel.get_root_die().transform.basis.get_rotation_quat().get_euler()
	var dice_transform = DiceModel.positional_transforms.get(DiceModel.the_dice_side).get_euler()
	DropShadow.set_rotation(angle - dice_transform + Vector3(PI / 2, 0, 0))


func get_dice_model():
	return DiceModel

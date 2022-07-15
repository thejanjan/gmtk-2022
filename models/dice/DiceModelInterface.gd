extends Spatial


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

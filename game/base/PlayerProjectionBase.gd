extends Spatial


onready var DiceModel = $DiceModel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_dice_model():
	return DiceModel

extends Area2D


# Declare member variables here. Examples:
var baseSize = 1;
var length = 1;

func setup(baseSize, var length, var color):
	self.baseSize = baseSize
	self.length = length
	$CollisionShape2D/Sprite.modulate = color;

# Called when the node enters the scene tree for the first time.
func _ready():
	$Tween.interpolate_property($CollisionShape2D, "scale", Vector2(self.baseSize*13/4, self.baseSize*8/4), Vector2(0,0), self.length, Tween.TRANS_CUBIC , Tween.EASE_IN)
	$Tween.start()
	$Tween.interpolate_callback(self, self.length, "end")

func end():
	get_parent().remove_child(self)

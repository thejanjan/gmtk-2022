extends Area2D


# Declare member variables here. Examples:
var color
var collected := false


# Called when the node enters the scene tree for the first time.
func _ready():
	self.color = Color.khaki
	$Pedestal/KeySprite.modulate = self.color


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_KeyPedestal_body_entered(body):
	if body == GameState.get_player() and not collected:
		collected = true
		$Pedestal/KeySprite/AnimationPlayer.play("Collect")
		$AudioStreamPlayer.play()

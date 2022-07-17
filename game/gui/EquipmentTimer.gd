extends Control

onready var Text = $RichTextLabel

# Declare member variables here. Examples:
var active = false
var timer = -1.0


func _ready():
	$AnimationPlayer.play("Deactivate")
	$AnimationPlayer.seek(2.0)
	
	GameState.get_player().get_rigid_body().connect("set_cooldown", self, "set_timer")


func _process(delta):
	timer -= delta
	
	# Set the text.
	var time_left = max(float(round(timer * 10)) / 10.0, 0.0)
	if round(time_left) != time_left:
		Text.text = str(time_left)
	else:
		Text.text = str(time_left) + '.0'
	
	# Too far?
	if active and timer <= 0.0:
		active = false
		$AnimationPlayer.play("Deactivate")
	

func set_timer(amount: float):
	self.timer = amount
	active = true
	$AnimationPlayer.play("Activate")

extends RigidBody2D

enum State {
	NORMAL,
	BROKEN
}

var current_state = State.NORMAL

func _on_body_entered(body: Node):
	if current_state == State.NORMAL and str(body.get_path()).ends_with("/Player"):
		break_urn()

func break_urn():
	current_state = State.BROKEN
	$AnimatedSprite.playing = true
	$Timer.start()

# use the timer to deactivate physics a moment after breaking
func _on_timer():
	self.mode = MODE_KINEMATIC
	$CollisionShape2D.disabled = true

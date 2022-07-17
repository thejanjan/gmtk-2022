extends RigidBody2D

enum State {
	NORMAL,
	BROKEN
}

var current_state = State.NORMAL

func handle_player_collision(collision: KinematicCollision2D):
	if current_state == State.NORMAL:
		self.apply_central_impulse(collision.remainder * 250)
		break_urn()

func break_urn():
	current_state = State.BROKEN
	$Sprite.playing = true
	$Timer.start()
	$AudioStreamPlayer.play()

# use the timer to deactivate physics a moment after breaking
func _on_timer():
	$CollisionShape2D.disabled = true

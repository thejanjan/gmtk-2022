extends EnemyBase

onready var AnimPlayer = $AnimationPlayer
	
func perform_destroy():
	set_collision_layer(0)
	set_collision_mask(0)
	AnimPlayer.play("Death")

func _on_Timer_timeout():
	var xpos = Random.choice([-1, 1])
	var ypos = Random.choice([-1, 1])
	move_tile(xpos, ypos, 0.5);

func _on_AnimationPlayer_animation_finished(anim_name):
	self.queue_free()

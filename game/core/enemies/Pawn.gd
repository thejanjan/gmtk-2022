extends EnemyBase

onready var AnimPlayer = $AnimationPlayer

func perform_destroy():
	set_collision_layer(0)
	set_collision_mask(0)
	AnimPlayer.play("Death")

func _on_Timer_timeout():
	if self.hp > 0:
		move_tile(-1, 0, 0.4);

func _on_AnimationPlayer_animation_finished(anim_name):
	self.queue_free()

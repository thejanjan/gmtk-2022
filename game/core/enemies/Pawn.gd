extends EnemyBase

onready var AnimPlayer = $AnimationPlayer

func _ready():
	set_health(10);

func perform_destroy():
	AnimPlayer.play("Death")

func _on_Timer_timeout():
	if self.hp > 0:
		move_tile(-1, 0, 0.4);

func _on_AnimationPlayer_animation_finished(anim_name):
	self.queue_free()

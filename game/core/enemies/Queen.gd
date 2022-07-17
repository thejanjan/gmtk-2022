extends EnemyBase

onready var AnimPlayer = $AnimationPlayer
var xpos = 0
var ypos = 0
	
func perform_destroy():
	set_collision_layer(0)
	set_collision_mask(0)
	AnimPlayer.play("Death")

func _on_Timer_timeout():
	while (xpos == 0) and (ypos == 0):
		xpos = Random.choice([-1, 0, 1])
		ypos = Random.choice([-1, 0, 1])
	
	move_tile(xpos, ypos, 0.5);

func _on_AnimationPlayer_animation_finished(anim_name):
	self.queue_free()


func _on_Queen_collision():
	xpos = 0
	ypos = 0

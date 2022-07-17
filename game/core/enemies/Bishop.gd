extends EnemyBase

onready var AnimPlayer = $AnimationPlayer
var xpos = 0
var ypos = 0
	
func perform_destroy():
	set_collision_layer(0)
	set_collision_mask(0)
	AnimPlayer.play("Death")

func _on_Timer_timeout():
#	# attempt up to 4 times to reroll movement direction if it can't currently move
	for i in range(0, 4):
		if (xpos == 0 and ypos == 0) or !check_move(xpos, ypos): # can it move the same way again?
			# no it can't
			xpos = Random.choice([-1, 1])
			ypos = Random.choice([-1, 1])
		else: # yes it can!
			break
	
	move_tile(xpos, ypos, 0.5)

func _on_AnimationPlayer_animation_finished(anim_name):
	self.queue_free()

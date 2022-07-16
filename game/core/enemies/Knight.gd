extends EnemyBase

onready var AnimPlayer = $AnimationPlayer
var xpos = 0
var ypos = 0
var knightmove = 0
var currentknightpos = 1
	
func perform_destroy():
	set_collision_layer(0)
	set_collision_mask(0)
	AnimPlayer.play("Death")

func _on_Timer_timeout():
	if (xpos == 0) and (ypos == 0):
		knightmove = randi() % 8
	
	knightmovement()
	move_tile(xpos, ypos, 0.5);

func _on_AnimationPlayer_animation_finished(anim_name):
	self.queue_free()


func _on_Knight_collision():
	xpos = 0
	ypos = 0
	currentknightpos = 1

func knightmovement():
	if currentknightpos == 0:
		xpos = 0
		ypos = 0
		currentknightpos = 1
	elif (currentknightpos == 1) or (currentknightpos == 2):
		if (knightmove == 0) or (knightmove == 1):
			xpos = -1
		elif (knightmove == 2) or (knightmove == 3):
			xpos = 1
		elif (knightmove == 4) or (knightmove == 5):
			ypos = -1
		elif (knightmove == 6) or (knightmove == 7):
			ypos = 1
		currentknightpos += 1
	elif currentknightpos == 3:
		if  (knightmove == 0) or (knightmove == 1):
			xpos = 0
			ypos = -1
		elif (knightmove == 2) or (knightmove == 3):
			xpos = 0
			ypos = 1
		elif (knightmove == 4) or (knightmove == 5):
			ypos = 0
			xpos = -1
		elif (knightmove == 6) or (knightmove == 7):
			ypos = 0
			xpos = 1
		currentknightpos = 0

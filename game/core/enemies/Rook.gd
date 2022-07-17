extends EnemyBase

onready var AnimPlayer = $AnimationPlayer
var xpos = 0
var ypos = 0
	
func perform_destroy():
	set_collision_layer(0)
	set_collision_mask(0)
	AnimPlayer.play("Death")

func _on_Timer_timeout(): 
	generic_move()
	
func get_valid_moves():
	var base_list = [
		Vector2(1, 0),
		Vector2(0, 1),
		Vector2(-1, 0),
		Vector2(0, -1)
	]
	var ret_list = []
	for i in range(1, 5):
		for vec2 in base_list:
			ret_list.append(vec2 * i)
	return ret_list

func _on_AnimationPlayer_animation_finished(anim_name):
	self.queue_free()


func _on_Rook_collision():
	xpos = 0
	ypos = 0

extends EnemyBase

onready var AnimPlayer = $AnimationPlayer

var move_list = [Vector2(-1, 0), Vector2(1, 0), Vector2(0, 1), Vector2(0, -1)]
var direction = Random.choice(move_list)

func _on_Timer_timeout(): 
	if not check_move(direction.x, direction.y):
		direction = Random.choice(move_list)
	generic_move()
	
func get_valid_moves():
	return [direction]

func _on_AnimationPlayer_animation_finished(anim_name):
	self.queue_free()

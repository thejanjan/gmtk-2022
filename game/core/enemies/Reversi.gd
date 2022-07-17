extends EnemyBase

onready var AnimPlayer = $Sprite
var xpos = 0
var ypos = 0
var whiteup = 0
	
func perform_destroy():
	set_collision_layer(0)
	set_collision_mask(0)
	#AnimPlayer.play("Death")

func _on_Timer_timeout(): 
	AnimPlayer.stop()
	$CollisionShape2D.scale = Vector2(1,1)
	xpos = Random.choice([-1, 0, 1])
	ypos = Random.choice([-1, 0, 1])
	
	if (xpos == 0) and (ypos == 0):
		if whiteup == 0:
			AnimPlayer.play("Black To White")
			whiteup = 1
		else:
			AnimPlayer.play("White To Black")
			whiteup = 0
		$CollisionShape2D.scale = Vector2(5,5)
	else:
		generic_move()

func get_valid_moves():
	return [
		Vector2(1, 0),
		Vector2(0, 1),
		Vector2(-1, 0),
		Vector2(0, -1)
	]

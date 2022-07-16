extends EnemyBase

onready var AnimPlayer = $AnimationPlayer

func _ready():
	set_health(20);
	randomize()
	
func perform_destroy():
	AnimPlayer.play("Death")

func _on_Timer_timeout():
	var xpos = Random.choice([-1, 1])
	var ypos = Random.choice([-1, 1])
	move_tile(xpos, ypos, 0.5);

func _on_AnimationPlayer_animation_finished(anim_name):
	self.queue_free()

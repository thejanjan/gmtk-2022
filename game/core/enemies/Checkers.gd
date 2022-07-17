extends EnemyBase

onready var AnimPlayer = $AnimationPlayer
var xpos = 0
var ypos = -1
var spritetex = preload("res://textures/enemies/checker/red_checker.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered", self, "_on_body_entered")
	randomize()
	GameState.check_tile(self.position, "Enemy");
	if (randi() % 2) == 1:
		$Sprite.set_texture(spritetex)
		ypos = 1

func perform_destroy():
	set_collision_layer(0)
	set_collision_mask(0)
	AnimPlayer.play("Death")

func _on_Timer_timeout(): 
	xpos = Random.choice([-1, 0, 1])
	
	move_tile(xpos, ypos, 0.5);

func _on_AnimationPlayer_animation_finished(anim_name):
	self.queue_free()

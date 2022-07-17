extends EnemyBase

onready var AnimPlayer = $AnimationPlayer
var xpos = 0
var ypos = 0
var playerdistance = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered", self, "_on_body_entered")
	randomize()
	if (randi() % 2) == 1:
		$Sprite.set_texture("res://textures/enemies/go/white_go.png")
	
func perform_destroy():
	set_collision_layer(0)
	set_collision_mask(0)
	AnimPlayer.play("Death")

func _on_Timer_timeout(): 
	playerdistance = find_player()

func _on_AnimationPlayer_animation_finished(anim_name):
	self.queue_free()

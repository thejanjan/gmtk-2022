extends EnemyBase

onready var AnimPlayer = $AnimationPlayer
var xpos = 0
var ypos = 0
var playerdistance = Vector2(0,0)
var spritetex = preload("res://textures/enemies/go/white_go.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered", self, "_on_body_entered")
	randomize()
	if (randi() % 2) == 1:
		$Sprite.set_texture(spritetex)

func perform_destroy():
	set_collision_layer(0)
	set_collision_mask(0)
	AnimPlayer.play("Death")

func _on_Timer_timeout(): 
	if (playerdistance.x == 0) and (playerdistance.y == 0):
		playerdistance = find_player()
	
	if (playerdistance.x < 0):
		xpos = -1
		playerdistance.x += 1
	elif (playerdistance.x > 0):
		xpos = 1
		playerdistance.x -= 1
	else:
		xpos = 0
	
	if (playerdistance.y < 0):
		ypos = -1
		playerdistance.y += 1
	elif (playerdistance.y > 0):
		ypos = 1
		playerdistance.y -= 1
	else:
		ypos = 0
	
	move_tile(xpos, ypos, 0.5)

func _on_AnimationPlayer_animation_finished(anim_name):
	self.queue_free()

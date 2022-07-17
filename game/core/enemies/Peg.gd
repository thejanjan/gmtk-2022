extends EnemyBase

onready var AnimPlayer = $AnimationPlayer
var white = preload("res://textures/enemies/battleship/white_peg.png");
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func perform_destroy():
	set_collision_layer(0)
	set_collision_mask(0)
	AnimPlayer.play("Death")

# Called when the node enters the scene tree for the first time.
func _ready():
	if randf() > 0.5:
		$Sprite.texture = white;
	set_collision_layer(1);
	set_collision_mask(1);
	contact_monitor = true;
		
func init(start_pos : Vector2):
	self.position = start_pos;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Peg_collision():
	$Timer.die();
	print("Time to die!")

func _on_Timer_timeout():
	self.perform_destroy();
	
func _on_body_entered(body: Node):
	$Timer.die();
	print("Time to die!")

func _on_Peg_body_entered(body):
	$Timer.die();
	print("Time to die!")

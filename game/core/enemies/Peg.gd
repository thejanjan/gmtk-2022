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
		
func init(start_pos : Vector2):
	self.position = start_pos;

func handle_player_collision():
	$Timer.die();

func _on_Timer_timeout():
	self.perform_destroy();

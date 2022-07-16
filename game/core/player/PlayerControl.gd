extends Sprite

var Item = load("res://game/core/Item.gd")
var PlayerStats = load("res://game/core/player/PlayerStats.gd")

var _stats = PlayerStats.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	_stats._speed = 3;
	_stats._damage = 1;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var h_move = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	var v_move = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	self.translate(Vector2(h_move * _stats._speed, v_move * _stats._speed))

func apply_item(item):
	_stats._speed += item._stats._speed
	_stats._damage += item._stats._damage

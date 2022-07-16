extends KinematicBody2D

const Item = preload("res://game/core/Item.gd")
const PlayerStats = preload("res://game/core/player/PlayerStats.gd")

var _stats = PlayerStats.new()

onready var PlayerSprite = $PlayerSprite
onready var PlayerState = $State/StateMachine

var SideEquipment = {
	Enum.DiceSide.ONE : "PipDamage",
	Enum.DiceSide.TWO : "PipDamage",
	Enum.DiceSide.THREE : "PipDamage",
	Enum.DiceSide.FOUR : "PipDamage",
	Enum.DiceSide.FIVE : "PipDamage",
	Enum.DiceSide.SIX : "PipDamage"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	_stats._speed = 30;
	_stats._damage = 1;
	PlayerState.transition("PipDamage");
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var h_move = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	var v_move = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	var velocity = Vector2(h_move * _stats._speed, v_move * _stats._speed)
	velocity = move_and_slide(velocity)
	for i in get_slide_count():
			var collision = get_slide_collision(i)
			print("I collided with ", collision.collider.name)
	# self.translate()

func apply_item(item):
	_stats._speed += item._stats._speed
	_stats._damage += item._stats._damage


func get_player_sprite():
	return PlayerSprite

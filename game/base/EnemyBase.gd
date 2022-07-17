extends RigidBody2D
class_name EnemyBase

const tile_height = 8;
const tile_width = 13;

signal health_changed
signal enemy_killed
signal enemy_moved
signal collision

# Declare member variables here. Examples:
export var max_hp = 10
var hp = 10
var prickly := false

# The code to obtain these values hasn't been written yet
var playerx = 0 
var playery = -21

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered", self, "_on_body_entered")
	randomize()
	GameState.check_tile(self.position, "Enemy");

func init(pos : Vector2):
	self.position = pos;

"""
Health modifiers
"""

func set_health(hp):
	self.max_hp = hp
	self.hp = hp
	
func lose_health(damage):
	GameState.make_text(self, "-" + str(damage), "f80")
	if self.hp > 0:
		self.hp -= damage
		emit_signal("health_changed", self.hp, self.max_hp)
	if self.hp <= 0:
		emit_signal("enemy_killed")
		GameState.make_cash(Random.randint(2, 4))
		self.perform_destroy()
		
func perform_destroy():
	GameState.remove_space(self.position);
	self.queue_free()
	
"""
Movement
"""

func check_move(x, y):
	return GameState.check_tile(self.position + Vector2(x * self.tile_width * 4, y * self.tile_height * 4), "Enemy") != Vector2.INF

func finish_move(_obj, _key):
	prickly = false

func move_tile(x, y, duration):
	if check_move(x, y):
		GameState.remove_space(self.position);
		var tween = self.make_tween()
		tween.interpolate_property(
			self, "position", self.position,
			self.position + Vector2(x * self.tile_width * 4, y * self.tile_height * 4),
			duration, Tween.TRANS_LINEAR, Tween.EASE_OUT
		)
		tween.start()
		prickly = true
		tween.connect("tween_completed", self, "finish_move")
		emit_signal("enemy_moved")

func find_player() -> Vector2:
	playerx = int(playerx) - (int(playerx) % self.tile_width)
	playery = int(playery) - (int(playery) % self.tile_height)
	
	var enemyx = int(self.position.x) - (int(self.position.x) % self.tile_width)
	var enemyy = int(self.position.y) - (int(self.position.y) % self.tile_height)
	
	var tilex = (playerx - enemyx) / self.tile_width / 4
	var tiley = (playery - enemyy) / self.tile_height / 4
	
	return Vector2(tilex, tiley) # returns number of tiles away from player
	
"""
Collisions
"""

func _on_body_entered(body: Node):
	var non_internal_groups = []
	for group in get_groups():
		if not group.begins_with("_"):
			non_internal_groups.push_back(group)
	
	# Communicate this to the enemy base.
	for group in non_internal_groups:
		self.on_collision_from(body, group)

func on_collision_from(body: Node, group: String):
	emit_signal("collision")

"""
Getters
"""

func get_hp():
	return self.hp
	
func get_max_hp():
	return self.max_hp

"""
Helpers
"""

func make_tween() -> TempTween:
	var tween = TempTween.new()
	self.add_child(tween)
	return tween

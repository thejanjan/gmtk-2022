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

var agro = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered", self, "_on_body_entered")
	randomize()
	GameState.check_tile(self.position, "Enemy");
	
	var timer = $Timer
	if timer != null:
		timer.move_delay = BeasTiary.EnemyMoveDuration
	set_health(self.max_hp)

func init(pos : Vector2):
	self.position = pos;

"""
Health modifiers
"""

func set_health(hp):
	self.max_hp = hp
	self.hp = hp
	
func lose_health(damage):
	agro = true
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
	
func _process(delta):
	if Input.is_action_just_pressed("move_roll"):
		var player_pos = GameState.get_player().position
		var astar = self.get_astar() as AStar2D
		var end_id = astar.get_closest_point(player_pos)
		print(astar.get_point_connections(end_id))
	
"""
Movement
"""

func check_move(x, y):
	return GameState.check_tile(self.position + Vector2(x * self.tile_width * 4, y * self.tile_height * 4), "Enemy") != Vector2.INF
	
func get_move_score(x = 0, y = 0) -> int:
	# Given a move, returns the number of steps required to reach the player.
	var player_pos = GameState.get_player().global_position
	var u_player_pos = (player_pos / (Vector2(13, 8) * 4)) - Vector2(0.5, 0.5)
	var our_pos = self.position
	var u_our_pos = (our_pos / (Vector2(13, 8) * 4)) - Vector2(0.5 - x, 0.5 - y)
	
	# Get the IDs in astar land.
	var astar = self.get_astar() as AStar2D
	var end_id = astar.get_closest_point(u_player_pos)
	var start_id = astar.get_closest_point(u_our_pos)
	
	# Get the connection and return the cost.
	return astar.get_id_path(end_id, start_id).size()

func finish_move(_obj, _key):
	prickly = false

func move_tile(x, y, duration):
	if not agro:
		var move_score = self.get_move_score()
		if move_score < 14:
			agro = true
	
	if check_move(x, y):
		duration = BeasTiary.EnemyVisualMoveDuration
		GameState.remove_space(self.position);
		var tween = self.make_tween()
		tween.interpolate_property(
			self, "position", self.position,
			self.position + Vector2(x * self.tile_width * 4, y * self.tile_height * 4),
			duration, Tween.TRANS_CUBIC, Tween.EASE_OUT
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
	
func generic_move():
	if not agro:
		var move_order = Random.shuffle(self.get_valid_moves().duplicate())
		while move_order:
			var move = move_order.pop_back()
			if check_move(move.x, move.y):
				# This move is safe, we can perform it.
				move_tile(move.x, move.y, BeasTiary.EnemyVisualMoveDuration)
				return
		# No moves existed, do nothing.
		pass
	else:
		# We have agro, chance the player down.
		var best_move_score = 100000
		var best_move = null
		for move in self.get_valid_moves():
			if not check_move(move.x, move.y):
				continue
			var move_score = get_move_score(move.x, move.y)
			if move_score < best_move_score:
				best_move_score = move_score
				best_move = move
		
		if best_move != null:
			# Perform the optimal move.
			move_tile(best_move.x, best_move.y, BeasTiary.EnemyVisualMoveDuration)

func get_valid_moves() -> Array:
	return []
	
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

"""
A* handlers
"""

func get_astar() -> AStar2D:
	return GameState.get_dungeon().astar

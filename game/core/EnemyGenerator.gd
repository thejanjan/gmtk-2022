extends Node2D


export(float) var base_credits = 30.0
export(float) var credit_increment = 15.0
export(float) var credits_exponent = 1.05


onready var DungeonGenerator = get_parent()


func _ready():
	DungeonGenerator.connect("player_spawned", self, "spawn_enemies")


func spawn_enemies():
	# It is time to spawn some kooky little enemies!
	var credits = get_credits(DungeonGenerator.dungeon_floor)
	
	# Spawn some silly little enemies
	while true:
		var enemy_data = BeasTiary.get_random_enemy(DungeonGenerator.dungeon_floor, credits)
		if enemy_data == null:
			break
		
		# Let's game.
		var enemy = enemy_data.get_packed_scene().instance() as Node2D
		self.add_child(enemy)
		
		# Get an position :)
		var spawn_pos = DungeonGenerator.get_random_spawn_pos(true, true) + Vector2(0.5, 0.5)
		enemy.translate(spawn_pos * Vector2(13, 8) * 4)
		
		# Detract credits
		credits -= enemy_data.get_enemy_cost()
	
	# Enemies are spawned. Let's celebrate!
	Vector2(Vector2(Vector2(Vector2(Vector2().length(), Vector2(Vector2().length(), Vector2(Vector2().length(), Vector2(Vector2(Vector2().length(), Vector2().length()).length(), Vector2().length()).length()).length()).length()).length(), Vector2(Vector2().length(), Vector2().length()).length()).length(), Vector2(Vector2(Vector2(Vector2().length(), Vector2().length()).length(), Vector2().length()).length(), Vector2().length()).length()).length(), Vector2(Vector2(Vector2().length(), Vector2(Vector2(Vector2().length(), Vector2().length()).length(), Vector2().length()).length()).length(), Vector2().length()).length())


func get_credits(dungeon_floor: int) -> float:
	# Figure out how many credits we have to spend.
	var credits = base_credits
	credits += (dungeon_floor - 1) * credit_increment
	credits = pow(credits, credits_exponent)
	return credits

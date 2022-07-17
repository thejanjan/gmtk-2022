extends EnemyBase

var vertical = preload("res://textures/enemies/battleship/vship_2.png");
onready var PegScene = preload("res://game/core/enemies/Peg.tscn");
onready var AnimPlayer = $AnimationPlayer
export var PegsFired = 2;
export var AttackRangeSquared = 22500;
var player;
var place_position;
var tileMap;

func perform_destroy():
	set_collision_layer(0)
	set_collision_mask(0)
	AnimPlayer.play("Death")
	
func _on_AnimationPlayer_animation_finished(anim_name):
	self.queue_free()
	
func _ready():
	._ready();
	tileMap = get_node("DungeonGenerator/FloorTileMap");
	if randf() > 0.5:
		#Vertical
		$Sprite.texture = vertical;
		$CollisionShape2D.rotate(PI/2);
		pass;
		
	place_position = self.position;
	
	#Get and store player for future use so we don't call this every second or whatever
	player = GameState.get_player();

func _on_Timer_timeout():
	#Just in case
	if (player == null):
		player = GameState.get_player();
	
	if (tileMap == null):
		tileMap = get_node("DungeonGenerator/FloorTileMap");
		
	if place_position.distance_squared_to(player.get_position()) < AttackRangeSquared:
		var shots = PegsFired;
		var attempts = 0;
		while shots > 0:
			attempts += 1;
			var location = Vector2(Random.randfn(-130, 130), Random.randfn(-80, 80));
			location = GameState.check_tile(location, "Peg");
			if location != Vector2.INF:
				var peg = PegScene.instance();
				peg.init(location);
				add_child(peg);
				shots -= 1;
			#Hey what if the area around the player is full? You think about that? Huh? Did you???? Bitch
			if attempts > 20:[]
				break;

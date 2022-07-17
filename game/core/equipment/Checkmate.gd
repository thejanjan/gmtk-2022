extends Equipment

func enter():
	var furthest_distance = 50000
	var player = self.get_player()
	var all_enemy = get_tree().get_nodes_in_group("chess_piece");
	var close_enemy = null;
	
	#Set this to the maximum distance^2 we want to search
	#Remember we use distance_SQUARED_to!!!
	var close_distance = furthest_distance;
	var pos = player.get_position();
	
	#Find closest enemy, ez
	for enemy in all_enemy:
		var p_to_enemy = pos.distance_squared_to(enemy.get_position());
		if p_to_enemy < close_distance:
			close_distance = p_to_enemy;
			close_enemy = enemy;
	
	# Kill
	if (close_enemy != null):
		close_enemy.lose_health(close_enemy.hp);
		$AudioStreamPlayer.play()

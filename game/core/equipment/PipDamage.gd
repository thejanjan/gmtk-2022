extends State

func enter():
	#PAIN
	var player = self.get_player()
	var pip = player.get_active_pip();
	
	var all_enemy = get_tree().get_nodes_in_group("enemy");
	var close_enemy = null;
	
	#Set this to the maximum distance^2 we want to search
	#Remember we use distance_SQUARED_to!!!
	var close_distance = 50000;
	var pos = player.get_position();
	
	#Find closest enemy, ez
	for enemy in all_enemy:
		var p_to_enemy = pos.distance_squared_to(enemy.get_position());
		if p_to_enemy < close_distance:
			close_distance = p_to_enemy;
			close_enemy = enemy;
	
	#Do damage equal to current pip
	if (close_enemy != null):
		close_enemy.lose_health(pip + 1);
		print(pip);

extends Equipment

func enter():
	var valid_enemies = []
	var pos = self.get_player().get_position();
	
	var nearest_enemy_distance = []
	var nearest_enemy_objs = []
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy.hp <= 0:
			continue
		
		var p_to_enemy = pos.distance_to(enemy.get_position());
		var inserted = false
		
		for i in nearest_enemy_distance.size():
			if p_to_enemy < nearest_enemy_distance[i]:
				nearest_enemy_distance.insert(i, p_to_enemy)
				nearest_enemy_objs.insert(i, enemy)
				inserted = true
				break
				
		if not inserted:
			nearest_enemy_distance.append(p_to_enemy)
			nearest_enemy_objs.append(enemy)
	
	for i in range(min(self.pip, nearest_enemy_objs.size())):
		nearest_enemy_objs[i].lose_health(1)

	$AudioStreamPlayer.play()

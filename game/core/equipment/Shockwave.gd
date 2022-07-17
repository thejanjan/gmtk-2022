extends Equipment

func enter():
	var valid_enemies = []
	var pos = self.get_player().get_position();
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
		var p_to_enemy = pos.distance_squared_to(enemy.get_position());
		if p_to_enemy < 100000 and enemy.hp > 0:
			valid_enemies.append(enemy)
	
	for i in range(self.pip):
		if not valid_enemies:
			break
		var enemy = valid_enemies.pop_back()
		enemy.lose_health(1)

	$AudioStreamPlayer.play()

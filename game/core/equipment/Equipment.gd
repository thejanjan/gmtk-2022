class_name Equipment
extends State

# Try to keep all the actual behavior in here so that it's easier to add variants


func damageNearbyEnemy(furthest_distance = 50000):
	#PAIN
	var player = self.get_player()
	var pip = player.get_active_pip();
	
	var all_enemy = get_tree().get_nodes_in_group("enemy");
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
	
	#Do damage equal to current pip
	if (close_enemy != null):
		close_enemy.lose_health(pip + 1);
		print(pip);

# Probably shouldn't use this directly, since it has no behavior for undoing the change
# Done with multipliers instead of absolute values so that changes can stack properly
func _statChange(stat, multiplier):
	var stats = get_player()._stats
	var og = stats.get(stat)
	stats.set(stat, stats.get(stat) * multiplier)
	print("Set {0} from {1} to {2}".format([stat, og, stats.get(stat)]))

func tempStatChange(stat, multiplier, secondDuration):
	_statChange(stat, multiplier)
	yield(get_tree().create_timer(secondDuration), "timeout")
	_statChange(stat, 1.0/float(multiplier))

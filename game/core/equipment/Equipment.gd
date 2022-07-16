class_name Equipment
extends State

# Try to keep all the actual behavior in here so that it's easier to add variants
var pip = null
var timers = {}


func damageNearbyEnemy(furthest_distance = 50000):
	#PAIN
	var player = self.get_player()
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
		close_enemy.lose_health(self.pip + 1);
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


"""
Timer Logic
"""

func start_timer(timer_key, duration: float, callback: FuncRef, extra_args: Array = []):
	"""
	Starts a timer.
	"""
	# Set the timer key.
	if timer_key in self.timers.keys():
		# Do not run timers of the same key!
		push_error("Do not run timers of the same key!")
	
	self.timers[timer_key] = [callback, extra_args]
	
	# Create a timer.
	var timer = get_tree().create_timer(duration)
	
	# Perform it.
	yield(timer, "timeout")
	
	# Perform callback.
	self.stop_timer(timer_key, true)
	
func stop_timer(timer_key, perform_callback: bool = true):
	"""
	Stops a timer, if it is still going.
	Can choose to perform the callback.
	"""
	if timer_key in self.timers.keys():
		# The timer is still active, so we can kill it.
		var timer_data = self.timers[timer_key] as Array
		self.timers.erase(timer_key)
		
		# Perform the callback if we have not yet already.
		if perform_callback:
			var callback = timer_data[0] as FuncRef
			var extra_args = timer_data[1] as Array
			callback.call_funcv(extra_args)

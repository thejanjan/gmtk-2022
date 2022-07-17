class_name Equipment
extends State

onready var trail = preload("res://game/core/equipment/helpers/Trail.tscn")
onready var swoosh = preload("res://game/core/equipment/helpers/Swoosh.tscn")

# Try to keep all the actual behavior in here so that it's easier to add variants
var pip = null
var timers = {}
var changedConcreteSound = false

# Does this equipment reset pip stacks?
func get_reset_pip_stacks() -> bool:
	return true

func exit():
	# Stops autostop timers
	for k in timers.keys():
		var i = timers[k]
		if i[2]:
			self.stop_timer(k)
	# Resets changed sounds
	if changedConcreteSound:
	 changeConcreteSound("res://audio/concrete.ogg")

func damageNearbyEnemy(furthest_distance = 50000, damage_override = null):
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
		if p_to_enemy < close_distance and enemy.hp > 0:
			close_distance = p_to_enemy;
			close_enemy = enemy;
	
	#Do damage equal to current pip
	if (close_enemy != null):
		if damage_override == null:
			close_enemy.lose_health(self.pip);
		else:
			close_enemy.lose_health(damage_override);
		print(pip);
		# Draw a lil guy
		var instance = self.swoosh.instance()
		player.get_parent().add_child(instance)
		instance.position = player.position
		instance.rotation_degrees = instance.position.angle_to_point(close_enemy.position) * 180 / PI - 90
		instance.scale.x = 2
		instance.scale.y = furthest_distance / 2777

func createTrail(size, length, color):
	var instance = self.trail.instance()
	instance.setup(size, length, color)
	var player = get_player()
	player.get_parent().add_child(instance)
	instance.position = player.position

func changeConcreteSound(res):
	get_player().change_audio_to(res)

# Probably shouldn't use this directly, since it has no behavior for undoing the change
# Done with multipliers instead of absolute values so that changes can stack properly
func _statChange(stat, multiplier):
	var stats = get_player()._stats
	var og = stats.get(stat)
	stats.set(stat, stats.get(stat) * multiplier)
	return
	
	print("Set {0} from {1} to {2}".format([stat, og, stats.get(stat)]))
	# Show with particles
	var player = get_player()
	var ud = multiplier > 0
	if stat in player._stats._inverted_stats:
		ud = !ud
	ud = "_up" if ud else "_down"
	var partSprite = "res://textures/items/stat_particles/" + stat + ud + ".png"
	if ResourceLoader.exists(partSprite):
		var part = get_player().get_node("CPUParticles2D").duplicate()
		player.add_child(part)
		print(player.get_children().size())
		part.emitting = true
		part.amount = ceil(multiplier/5.0)
		part.texture = load(partSprite)
		
		# Doesn't use timer because it was being a bitch
		# Deletes it to not memory leak
		var timer = get_tree().create_timer(2)
		yield(timer, "timeout")
		part.queue_free()

func tempStatChange(stat, multiplier, secondDuration, autostop=false):
	_statChange(stat, multiplier)
	self.start_timer(
		stat + "_change",
		secondDuration,
		funcref(self, "_statChange"),
		[stat, 1.0 / multiplier],
		autostop
	)


"""
Timer Logic
"""

func start_timer(timer_key, duration: float, callback: FuncRef, extra_args: Array = [], autostop=false):
	"""
	Starts a timer.
	
	Autostop performs the callback when the state changes.
	"""
	# Set the timer key.
	if timer_key in self.timers.keys():
		# Do not run timers of the same key!
		push_error("Do not run timers of the same key!")
	
	self.timers[timer_key] = [callback, extra_args, autostop]
	
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

extends StateMachine
class_name EquipmentStateMachine

"""
An extension of the StateMachine, that handles
generating temporary, finite nodes for equipment.
"""


func transition(item_type, dice_side: int = 0, cleanup_state: bool = true) -> State:
	# Exit our old state.
	if self.state != null:
		self.state.exit();
	var old_state = self.state;
	
	# Make the new node.
	var equipment_node = Database.get_item_data(item_type).load_resource().instance() as State
	self.add_child(equipment_node)
	self.state = equipment_node;
	
	# Do pip applications.
	var playerStats = GameState.get_player()._stats
	var pip_mult = 1.0 + float(playerStats._pip_stacks)
	equipment_node.pip = float(dice_side + 1) * pip_mult
	
	if self.state.get_reset_pip_stacks():
		playerStats._pip_stacks = 0
		GameState.get_player().emit_signal("pip_stacks_updated", 0)
	
	# Enter the new state.
	self.state.enter();
	emit_signal("change_state", self.state.name);
	
	# Detach our old state note.
	if cleanup_state:
		# Clean up the node the next frame.
		if old_state != null:
			old_state.queue_free()
		return null
	else:
		# Remove it as a child, and return it.
		if old_state != null:
			self.remove_child(old_state)
		return old_state


func get_player_pip():
	var player = GameState.get_player()
	return player.get_active_pip()

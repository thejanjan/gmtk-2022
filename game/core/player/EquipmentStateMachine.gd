extends StateMachine
class_name EquipmentStateMachine

"""
An extension of the StateMachine, that handles
generating temporary, finite nodes for equipment.
"""


func transition(item_type, cleanup_state: bool = true) -> State:
	# Exit our old state.
	if self.state != null:
		self.state.exit();
	var old_state = self.state;
	
	# Make the new node.
	var equipment_node = Database.get_item_data(item_type).load_resource().instance() as State
	self.add_child(equipment_node)
	self.state = equipment_node;
	
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

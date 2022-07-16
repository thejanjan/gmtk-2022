extends Node
class_name StateMachine

#Send out a signal if we change states, might be needed? Enemy who reacts to this too?
signal change_state(state_name);

#When game starts up, set the initial state
onready var state: State = null;

#When we're ready, set everything up
func _ready():
	for child in get_children():
		child.state_machine = self;

#Pass input events -only- to the current active state
func _unhandled_input(event: InputEvent):
	if state != null:
		state.handle_input(event);
	
#Pass update only to current active state
func _process(delta: float):
	if state != null:
		state.update(delta);
	
#Physics process only to current active state
func _physics_process(delta: float):
	if state != null:
		state.physics_update(delta);
	
#Transition to new state
func transition(target_state: String):
	if not has_node(target_state):
		return;
	
	if state != null:
		state.exit();
	state = get_node(target_state);
	state.enter();
	emit_signal("change_state", state.name);

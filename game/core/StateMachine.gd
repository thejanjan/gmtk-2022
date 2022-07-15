extends Node
class_name StateMachine

#Send out a signal if we change states, might be needed? Enemy who reacts to this too?
signal change_state(state_name);

#Customize initial state
export var initial_state := NodePath();

#When game starts up, set the initial state
onready var state: State = get_node(initial_state);

#When we're ready, set everything up
func _ready():
	for child in get_children():
		child.state_machine = self;
	state.enter();

#Pass input events -only- to the current active state
func _unhandled_input(event: InputEvent):
	state.handle_input(event);
	
#Pass update only to current active state
func _process(delta: float):
	state.update(delta);
	
#Physics process only to current active state
func _physics_process(delta: float):
	state.physics_update(delta);
	
#Transition to new state
func transition(target_state: String):
	if not has_node(target_state):
		return;
		
	state.exit();
	state = get_node(target_state);
	state.enter();
	emit_signal("change_state", state.name);

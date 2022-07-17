extends CanvasLayer

enum State {
	WAITING,
	HAS_MESSAGES,
	OUT_OF_MESSAGES,
	FINISHED
}

var current_state = State.WAITING
var characters = {
	"SNAKE GOD": Color("#7eff89"),
	"CHAOS GOD": Color("#ff9a75")
}
var messages = [
	{"name": "SNAKE GOD", "words": "Ooooh, and what do we have here. I don't remember inviting YOU, CHAOS GOD, to Board Games At The Bar."},
	{"name": "CHAOS GOD", "words": "Well, I'm here now, and I'm about to make it everybody's problem!"},
	{"name": "SNAKE GOD", "words": "No! I will NOT let you interfere with our game!!"},
	{"name": "CHAOS GOD", "words": "[LAUGH MANICALLY]"}
]
onready var clickto = $ClickTo
onready var display = $MarginContainer
onready var textholder = $MarginContainer/TextHolder

# Called when the node enters the scene tree for the first time.
func _ready():
	clickto.show()
	display.hide()

func begin():
	clickto.hide()
	display.show()
	current_state = State.HAS_MESSAGES
	add_next_message()

func add_next_message():
	# hide the next indicator of all prior messages
	for child in textholder.get_children():
		child.display_next(false)

	# make a new text box
	var new_textbox = preload("res://game/core/Textbox.tscn").instance()
	var message = messages.pop_front()
	var color = characters[message["name"]]
	new_textbox.set_text(message["name"], color, message["words"])
	textholder.add_child(new_textbox)

	# show/hide its next indicator
	new_textbox.display_next(len(messages) > 0)

	# update state?
	if len(messages) == 0:
		current_state = State.OUT_OF_MESSAGES

func finish():
	display.hide()
	current_state = State.FINISHED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("cutscene_continue"):
		match current_state:
			State.WAITING:
				begin()
			State.HAS_MESSAGES:
				add_next_message()
			State.OUT_OF_MESSAGES:
				finish()
			State.FINISHED:
				pass

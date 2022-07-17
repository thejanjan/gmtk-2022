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
	{
		"name": "SNAKE GOD",
		"words": "Ohhhh, and what do we have here. CHAOS GOD?"\
			   + " I don't remember inviting YOU to board games at the bar with usss.",
		"audio": "res://audio/voice/ck_inviting_you.ogg"
	},
	{
		"name": "CHAOS GOD",
		"words": "Well, I'm here now, and I'm about to make it everybody's problem!",
		"audio": "res://audio/voice/everybodys_problem.ogg"
	},
	{
		"name": "SNAKE GOD",
		"words": "NO! I will NOT let you mess up our gamess!!",
		"audio": "res://audio/voice/ck_mess_up_our_games.ogg"
	},
	{
		"name": "CHAOS GOD",
		"words": "[LAUGHS MANIACALLY]",
		"audio": "res://audio/voice/laugh.ogg"
	}
]
onready var clickto = $ClickTo
onready var display = $MarginContainer
onready var textholder = $MarginContainer/TextHolder
onready var player = $AudioStreamPlayer

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

	# play the associated audio
	if message["audio"]:
		var file = File.new()
		file.open(message["audio"], File.READ)
		var buffer = file.get_buffer(file.get_len())
		var stream = AudioStreamOGGVorbis.new()
		stream.data = buffer
		player.stream = stream
		player.play()
		# close the file
		file.close()

	# update state?
	if len(messages) == 0:
		current_state = State.OUT_OF_MESSAGES

func finish():
	display.hide()
	current_state = State.FINISHED
	player.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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

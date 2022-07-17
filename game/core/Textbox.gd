extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_text(character_name, color, words):
	$VBoxContainer/Name.add_color_override("font_color", color)
	$VBoxContainer/Name.text = character_name
	$VBoxContainer/Words.text = words

func display_next(should_display):
	$VBoxContainer/Next.visible = should_display

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

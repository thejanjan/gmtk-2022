extends Timer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var death_delay = 0.5;

# Called when the node enters the scene tree for the first time.
func _ready():
	set_wait_time(death_delay);

func die():
	start();
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

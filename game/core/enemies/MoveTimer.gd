extends Timer

export var move_delay = 1.5;
# Called when the node enters the scene tree for the first time.
func _ready():
	set_wait_time(move_delay);
	start();


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

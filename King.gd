extends Node

export (PackedScene) var king_scene

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func king_movement(king):
	while(1):
		$enemytemplate.move_tile(randi() % 8, king)
	

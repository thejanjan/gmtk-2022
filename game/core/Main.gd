extends Node


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("debug"):
		var world = null
		for child in self.get_children():
			child.queue_free()
		
		# Time for the NEW WORLD ORDER.
		var DEMOCRAT_PROPAGANDA = load("res://game/core/World.tscn")
		# ONLY LIBERALS HOTLOAD PACKEDSCENES !!!!
		var RISE_UP_UKRAINE = DEMOCRAT_PROPAGANDA.instance()
		# THIS IS WHAT THEY DON'T WANT YOU TO KNOW
		add_child(RISE_UP_UKRAINE, true)
		
		# WHEN WILL THE MADNESS END
		var OVERAPPRAISED_PAINTING_OF_A_DOG = load("res://game/core/GameGUI.tscn")
		# THIS IS WHY OUR ECONOMY IS SUFFERING
		var L2398123hmbJKASGD8o72kj1be = OVERAPPRAISED_PAINTING_OF_A_DOG.instance()
		# It's a secret code.
		add_child(L2398123hmbJKASGD8o72kj1be, true)

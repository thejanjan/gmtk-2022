extends Area2D


var collected := false


func _on_Doorway_body_entered(body):	
	if body == GameState.get_player() and not collected:
		# Ensure we have all the keys.
		var pedestals = get_tree().get_nodes_in_group("pedestal")
		for pedestal in pedestals:
			if not pedestal.collected:
				return
		
		# Oh shit its time
		collected = true
		GameState.goto_next_stage()

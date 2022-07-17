extends Control


var active_keys = []
		

func make_key_gui():
	var key_pedestals = get_tree().get_nodes_in_group("pedestal")
	var pedestal = key_pedestals[active_keys.size()]
	var key_gui = $KeyReference.duplicate()
	add_child(key_gui)
	key_gui.visible = true
	key_gui.modulate = pedestal.find_node("KeySprite").modulate / 3
	key_gui.rect_position -= Vector2(24 * active_keys.size(), 0)
	active_keys.append(key_gui)


func _process(delta):
	var key_pedestals = get_tree().get_nodes_in_group("pedestal")
	var total = key_pedestals.size()
	var current = 0
	while key_pedestals.size() > active_keys.size():
		make_key_gui()
	for i in range(key_pedestals.size()):
		var pedestal = key_pedestals[i]
		var key_gui = active_keys[i]
		if pedestal.collected:
			current += 1
			key_gui.modulate = pedestal.find_node("KeySprite").modulate
		else:
			key_gui.modulate = pedestal.find_node("KeySprite").modulate / 3
		

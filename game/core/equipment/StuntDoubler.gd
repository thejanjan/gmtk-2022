class_name StuntDoubler
extends Equipment

func enter():
	var scene = load("res://game/core/player/Player.tscn")
	var instance = scene.instance()
	add_child(instance)

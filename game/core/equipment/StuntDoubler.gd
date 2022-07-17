class_name StuntDoubler
extends Equipment

func enter():
	var playerStats = GameState.get_player()._stats
	playerStats._pip_stacks += 1
	GameState.get_player().emit_signal("pip_stacks_updated", playerStats._pip_stacks)


func get_reset_pip_stacks() -> bool:
	return false

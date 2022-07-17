class_name RubberOfTheSoul
extends Equipment

func enter():
	self.apply_stats(false)
	
func apply_stats(invert: bool):
	if not invert:
		GameState.get_player().velocity = Vector2(0, 0)
		_statChange("_speed", 5.0)
		_statChange("_acceleration", 1000.0)
		_statChange("_friction", 1000.0)
		_statChange("_bounciness", 100.0)
	else:
		_statChange("_speed", 1.0 / 5.0)
		_statChange("_acceleration", 1.0 / 1000.0)
		_statChange("_friction", 1.0 / 1000.0)
		_statChange("_bounciness", 1.0 / 100.0)
	
func exit():
	self.apply_stats(true)

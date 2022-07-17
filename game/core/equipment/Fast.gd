extends Equipment


func enter():
	self.apply_stats(false)
	
func apply_stats(invert: bool):
	if not invert:
		_statChange("_speed", self.get_speed_boost())
	else:
		_statChange("_speed", 1.0 / self.get_speed_boost())
		_statChange("_acceleration", 1.0 / 10.0)
	
func exit():
	self.apply_stats(true)

func get_speed_boost():
	return 1.3 + (self.pip * 0.15)

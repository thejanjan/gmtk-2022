extends Equipment


func enter():
	self._statChange("_speed", self.get_speed_boost())
	self.start_timer(
		"speed_change",
		15.0,
		funcref(self, "_statChange"),
		["_speed", 1.0 / self.get_speed_boost()]
	)
	
func exit():
	self.stop_timer("speed_change")

func get_speed_boost():
	return 1.3 + (self.pip * 0.15)

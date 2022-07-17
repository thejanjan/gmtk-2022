class_name BananaPeel
extends Equipment

func enter():
	self._statChange("_speed", 20.0)
	self.start_timer(
		"speed_change",
		0.25,
		funcref(self, "_statChange"),
		["_speed", 1.0 / 20.0]
	)
	
func exit():
	self.stop_timer("speed_change")

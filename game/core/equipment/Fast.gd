extends Equipment


func enter():
	self.tempStatChange("_speed", self.get_speed_boost(), 15, true)

func get_speed_boost():
	return 1.3 + (self.pip * 0.15)

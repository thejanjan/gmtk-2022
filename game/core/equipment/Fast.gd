extends Equipment


func enter():
	self.tempStatChange("_speed", 15, self.get_speed_boost(), true)

func get_speed_boost():
	return 1.3 + (self.pip * 0.15)

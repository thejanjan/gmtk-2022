class_name OilSlick
extends Equipment


func enter():
	self.apply_stats(false)
	changeConcreteSound("OilSplat")
	
func apply_stats(invert: bool):
	if not invert:
		_statChange("_speed", 3.0)
		_statChange("_acceleration", 10.0)
		_statChange("_friction", 20.0)
	else:
		_statChange("_speed", 1.0 / 3.0)
		_statChange("_acceleration", 1.0 / 10.0)
		_statChange("_friction", 1.0 / 20.0)
	
func exit():
	self.apply_stats(true)
	changeConcreteSound("ConcreteStream")

func _physics_process(delta):
	createTrail(1, 2, Color("#1a1a1f"))

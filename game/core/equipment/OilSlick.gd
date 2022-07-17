class_name OilSlick
extends Equipment

func enter():
	tempStatChange("_speed", 3, 15)
	tempStatChange("_acceleration", 10, 15)
	tempStatChange("_friction", 20, 15)

func _physics_process(delta):
	createTrail(1, 2, Color("#1a1a1f"))

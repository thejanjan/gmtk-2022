class_name OilSlick
extends Equipment

func enter():
	tempStatChange("_speed", 3, 15)
	tempStatChange("_acceleration", 10, 15)
	tempStatChange("_friction", 20, 15)

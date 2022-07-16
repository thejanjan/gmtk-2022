class_name RubberOfTheSoul
extends Equipment

func enter():
	tempStatChange("_speed", 5, 15)
	tempStatChange("_acceleration", 1000, 15)
	tempStatChange("_friction", 1000, 15)
	tempStatChange("_bounciness", 100, 15)

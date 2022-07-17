extends Node


func randint(start: int, end: int) -> int:
	# Returns a random integer from start to end.
	return start + (randi() % (end - start))
	
	
func choice(list: Array):
	# Returns a random element from a list.
	var index = randi() % list.size()
	return list[index]


func point_in_rect2(rect2: Rect2) -> Vector2:
	# Returns a random point in arect2.
	return rect2.position + Vector2(randint(0, rect2.size.x), randint(0, rect2.size.y))

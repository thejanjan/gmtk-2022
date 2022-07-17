extends Node


func randint(start: int, end: int) -> int:
	# Returns a random integer from start to end.
	if start == end:
		return start
	return start + (randi() % (end - start))
	
	
func choice(list: Array):
	# Returns a random element from a list.
	var index = randi() % list.size()
	return list[index]


func point_in_rect2(rect2: Rect2, border: int = 0) -> Vector2:
	# Returns a random point in arect2.
	if rect2.size.x - border < 0:
		return Vector2.INF
	if rect2.size.y - border < 0:
		return Vector2.INF
	
	return rect2.position + Vector2(randint(border, rect2.size.x - border), randint(border, rect2.size.y - border))

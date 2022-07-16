extends Node


func randint(start: int, end: int) -> int:
	# Returns a random integer from start to end.
	return start + (randi() % (end - start))
	
	
func choice(list: Array):
	# Returns a random element from a list.
	var index = randi() % list.size()
	return list[index]

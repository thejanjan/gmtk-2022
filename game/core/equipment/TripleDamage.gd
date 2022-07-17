extends Equipment

func enter():
	damageNearbyEnemy()
	start_timer("second_hit", 0.5, funcref(self, "second_hit"))
	start_timer("third_hit", 1.0, funcref(self, "third_hit"))
	
func second_hit():
	$AudioStreamPlayer.play()
	damageNearbyEnemy(75000)
	
func third_hit():
	damageNearbyEnemy(100000)

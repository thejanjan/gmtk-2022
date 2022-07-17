extends EnemyBase

onready var AnimPlayer = $AnimationPlayer
var xpos = 0
var ypos = 0

var valid_moves = [
	Vector2(1, 1),
	Vector2(1, -1),
	Vector2(-1, 1),
	Vector2(-1, -1)
]

func perform_destroy():
	set_collision_layer(0)
	set_collision_mask(0)
	AnimPlayer.play("Death")

func _on_Timer_timeout():
#	# attempt up to 4 times to reroll movement direction if it can't currently move
	if not agro:
		var move_order = Random.shuffle(valid_moves.duplicate())
		while move_order:
			var move = move_order.pop_back()
			if check_move(move.x, move.y):
				# This move is safe, we can perform it.
				move_tile(move.x, move.y, BeasTiary.EnemyVisualMoveDuration)
				return
		# No moves existed, do nothing.
		pass
	else:
		# We have agro, chance the player down.
		var best_move_score = 100000
		var best_move = null
		for move in valid_moves:
			if not check_move(move.x, move.y):
				continue
			var move_score = get_move_score(move.x, move.y)
			if move_score < best_move_score and move_score >= 2:
				best_move_score = move_score
				best_move = move
		
		if best_move != null:
			# Perform the optimal move.
			move_tile(best_move.x, best_move.y, BeasTiary.EnemyVisualMoveDuration)

func _on_AnimationPlayer_animation_finished(anim_name):
	self.queue_free()

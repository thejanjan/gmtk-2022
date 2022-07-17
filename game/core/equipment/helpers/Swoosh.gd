extends AnimatedSprite

func _ready():
	playing = true

func _on_AnimatedSprite_animation_finished():
	get_parent().remove_child(self)

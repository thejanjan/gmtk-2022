extends EquipPip

func set_tex_region(active: bool = false):
	var xpos = self.pip + 6
	PipSprite.texture.region = Rect2(xpos * 9, int(active) * 9, 9, 9)

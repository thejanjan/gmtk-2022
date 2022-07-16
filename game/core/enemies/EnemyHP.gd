extends ColorRect

onready var enemy = self.get_parent().get_parent()

onready var HPBacking = $HPBacking
onready var HPBar = $HPBacking/HPBar

var hp_ratio = 1.0
var width = 14
var destroyed = false

func _ready():
	self.set_width(width)
	self.enemy.connect("health_changed", self, "update_hp")	

func set_width(width: int):
	"""Sets the width of the HP bar."""
	self.width = width
	
	# Update all the rects.
	self.rect_size = Vector2(self.width * 4, 8)
	self.HPBacking.rect_size = Vector2(self.width * 4, 8)
	self.HPBar.rect_size = Vector2(self.width * 4, 8)
	
func update_hp(hp, max_hp):
	self.hp_ratio = float(hp) / float(max_hp)
	
	# Update the right margin of the HP Bar.
	var bar_width = self.rect_size.x * self.hp_ratio
	var goal_margin_pos = self.HPBar.margin_left + bar_width
	var tween = TempTween.new()
	self.add_child(tween)
	tween.interpolate_method(self, "_update_hp_margin", self.HPBar.margin_right, goal_margin_pos, 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	
	if self.hp_ratio <= 0.0 and not destroyed:
		self.destroyed = true
		self.fizzle_out()
	
func _update_hp_margin(x):
	self.HPBar.margin_right = x
	
func fizzle_out():
	var tween = TempTween.new()
	self.add_child(tween)
	var end_color = self.color
	end_color.a = 0
	tween.interpolate_property(self, "color", self.color, end_color, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	end_color = self.HPBacking.color
	end_color.a = 0
	tween.interpolate_property(self.HPBacking, "color", self.HPBacking.color, end_color, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	
	tween.start()

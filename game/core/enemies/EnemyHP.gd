extends Node2D

onready var enemy = self.get_parent()

onready var EnemyHP = $EnemyHP
onready var HPBacking = $EnemyHP/HPBacking
onready var HPBar = $EnemyHP/HPBacking/HPBar

var hp_ratio = 1.0
export var width = 14
var destroyed = false

func _ready():
	var width = round(pow(enemy.get_max_hp(), 0.7))
	self.set_width(width + 6)
	self.enemy.connect("health_changed", self, "update_hp")	

func set_width(width: int):
	"""Sets the width of the HP bar."""
	# Update all the rects.
	self.EnemyHP.rect_size = Vector2(width * 4, 8)
	self.EnemyHP.rect_position -= Vector2((width - 14) * 2, 0)
	self.HPBacking.rect_size = Vector2(width * 4, 8)
	self.HPBar.rect_size = Vector2(width * 4, 8)
	
func update_hp(hp, max_hp):
	self.hp_ratio = float(hp) / float(max_hp)
	
	# Update the right margin of the HP Bar.
	var bar_width = self.EnemyHP.rect_size.x * self.hp_ratio
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
	var end_color = self.EnemyHP.color
	end_color.a = 0
	tween.interpolate_property(self.EnemyHP, "color", self.EnemyHP.color, end_color, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	end_color = self.HPBacking.color
	end_color.a = 0
	tween.interpolate_property(self.HPBacking, "color", self.HPBacking.color, end_color, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	
	tween.start()

extends RichTextLabel
class_name FlyingText

var draw_text = 'Smile!'
var color = 'FF0000'

var lifetime = 3.0

var velocity = Vector2(0, 0)
const gravity = Vector2(0, 0.1)


func set_text(txt):
	self.draw_text = txt
	
	
func set_color(col):
	self.color = color


func empower():
	self.velocity += Vector2(float(Random.randint(-20, 20)) / 10, -randf() * 5)
	self.set_bbcode("[center][color=#" + self.color + "]" + self.draw_text + "[/color][/center]")
	
	
func _process(delta):
	self.lifetime -= delta
	if self.lifetime < 0:
		self.queue_free()


func _physics_process(delta):
	self.velocity += self.gravity
	self.rect_position += self.velocity

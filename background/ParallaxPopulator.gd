extends ParallaxLayer


"""
Populates the parallax BG with stupid fellas.
"""

var valid_textures = [
	preload("res://textures/enemies/chess/bishop.png"),
	preload("res://textures/enemies/chess/rook.png"),
	preload("res://textures/enemies/chess/pawn.png"),
	preload("res://textures/enemies/chess/knight.png"),
]


onready var target_node = $Node2D
var fill_count = 100

var x_offset = -1300
var y_offset = -900

var width = 2500
var height = 2000


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for i in range(fill_count):
		var node = target_node.duplicate()
		node.rotate(randf() * PI)
		node.translate(
			Vector2(randf() * self.width, randf() * self.height) + Vector2(self.x_offset, self.y_offset)
		)
		node.set_texture(Random.choice(self.valid_textures))
		node.scale = Vector2(1, 1) * ((randf() + 0.1) * 5)
		self.add_child(node)

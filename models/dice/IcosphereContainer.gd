extends Spatial


"""
This is such a bad idea
"""

onready var Icosphere = $Icosphere
var dice_count = 20
var offset = Vector3(0, 2.6, 0)
var die = []
var visible_die = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(dice_count):
		var container_spatial = Spatial.new()
		self.add_child(container_spatial)
		container_spatial.translate(self.offset * i)
		
		var new_dice = Icosphere.duplicate()
		container_spatial.add_child(new_dice)
		
		self.die.append(new_dice)
		new_dice.visible = false
		
	# Kill the original
	Icosphere.queue_free()
	self.get_root_die().visible = true


func get_dice_models() -> Array:
	return self.die


func get_root_die():
	return self.get_dice_models()[0]


func add_onto_stack():
	if self.visible_die >= self.dice_count:
		return
	var die = self.die[self.visible_die]
	self.visible_die += 1
	
	# Make this die visible.
	var animPlayer = die.get_node("AnimationPlayer")
	animPlayer.play("Spawn")
	

func clear_stack():
	if self.visible_die == 1:
		return
	
	for i in range(self.visible_die, 1, -1):
		# This dice will hide.
		var die = self.die[i - 1]
		var animPlayer = die.get_node("AnimationPlayer")
		yield(get_tree().create_timer(0.04), "timeout")
		animPlayer.play("Despawn")
		
	# Visible die resets.
	self.visible_die = 1

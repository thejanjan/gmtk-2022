extends Tween
class_name TempTween


"""
A tween the cleans itself up upon completion.
"""


func _ready():
	self.connect("tween_all_completed", self, "queue_free")

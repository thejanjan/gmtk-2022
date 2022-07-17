extends ColorRect



func _ready():
	var dungeon = GameState.get_dungeon()
	dungeon.connect("enter_floor", self, "new_floor")
	pass


func new_floor(dungeon_floor):
	if dungeon_floor == 3:
		self.color = Color.khaki
	if dungeon_floor == 5:
		self.color = Color.crimson

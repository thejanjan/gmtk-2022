extends Control
class_name EquipPip

onready var PipSprite = $PipSprite
onready var AtlasTex = preload("res://textures/player/EquipPip.tres")
onready var AnimPlayer := $AnimationPlayer
onready var TexAnimPlayer := $TexAnimPlayer
onready var TextLabel := $RichTextLabel
var pip = 0
var damaged = false
var active = false
var open_requests = []
var requested_open = false
var item_id = null

enum OpenRequests {
	HoldingTab,
	Plinth
}

func initialize(pip, item_id):
	self.pip = pip
	self.item_id = item_id
	var item_data = Database.get_item_data(self.item_id)
	PipSprite.texture = AtlasTexture.new()
	PipSprite.texture.atlas = item_data.get_icon_tex().duplicate()
	self.set_tex_region()
	TexAnimPlayer.play("Deactivate")
	TexAnimPlayer.seek(1.0, true)
	AnimPlayer.play("Idle")
	AnimPlayer.seek(self.pip / 3.0)
	
	
func set_item(item_id):
	self.item_id = item_id
	var item_data = Database.get_item_data(self.item_id)
	self.TextLabel.text = item_data.get_name()
	PipSprite.texture.atlas = item_data.get_icon_tex().duplicate()


func set_tex_region(active: bool = false):
	var xpos = self.pip 
	PipSprite.texture.region = Rect2(xpos * 9, int(active) * 9, 9, 9)


func _process(delta):
	# Listen for a "tab" open request.
	if Input.is_action_just_pressed("view_items"):
		self.open_requests.append(OpenRequests.HoldingTab)
	if Input.is_action_just_released("view_items"):
		self.open_requests.erase(OpenRequests.HoldingTab)
	
	# Set the tex anim player to be visible if that is what is desired.
	if not self.active:
		if self.open_requests and not self.requested_open:
			# We have requests to open, and we aren't open yet.
			self.requested_open = true
			TexAnimPlayer.play("Activate")
			
		elif not self.open_requests and self.requested_open:
			# We do not have requests to stay open, and we're still open.
			self.requested_open = false
			TexAnimPlayer.play("Deactivate")


func approach_plinth():
	if OpenRequests.Plinth in self.open_requests:
		return
	self.open_requests.append(OpenRequests.Plinth)
	
	
func unapproach_plinth():
	if OpenRequests.Plinth in self.open_requests:
		self.open_requests.erase(OpenRequests.Plinth)

	
func equip_pip(instant: bool = false):
	self.set_tex_region(true)
	self.active = true
	AnimPlayer.play("Activate")
	if not self.requested_open:
		TexAnimPlayer.play("Activate")
	if instant:
		AnimPlayer.seek(10)
		TexAnimPlayer.seek(10)
	
	
func unequip_pip(instant: bool = false):
	self.active = false
	self.set_tex_region(false)
	AnimPlayer.play("Deactivate")
	if not self.requested_open:
		TexAnimPlayer.play("Deactivate")
	if instant:
		AnimPlayer.seek(10)
		TexAnimPlayer.seek(10)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'Deactivate':
		AnimPlayer.play("Idle")
		AnimPlayer.seek(self.pip / 3)
		

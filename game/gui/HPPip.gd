extends Control

onready var PipSprite = $PipSprite
onready var AtlasTex = preload("res://textures/player/HP_StreamTexture.tres")
onready var AnimPlayer := $AnimationPlayer
var pip = 0;
var damaged = false;

func initialize(pip):
	self.pip = pip
	PipSprite.texture = AtlasTex.duplicate()
	var xpos = pip % 3
	var zpos = int(pip / 3)
	PipSprite.texture.region = Rect2(xpos * 9, zpos * 9, 9, 9)
	AnimPlayer.play("Idle")
	AnimPlayer.seek(self.pip / 3.0)
	
	
func hide_now():
	damaged = true
	AnimPlayer.play("Damage")
	AnimPlayer.seek(1)
	
	
func on_heal():
	damaged = false
	AnimPlayer.play("Heal")
	
	
func on_damage():
	damaged = true
	AnimPlayer.play("Damage")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'Damage' and damaged:
		return
	if anim_name in ["Damage", "Heal"]:
		AnimPlayer.play("Idle")
		AnimPlayer.seek(self.pip / 3)
		

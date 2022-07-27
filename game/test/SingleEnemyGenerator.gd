tool
extends Node2D

export(Enum.EnemyFlavor) var enemy_type = Enum.EnemyFlavor.PAWN setget set_enemy_type

var enemy_pckd = null
onready var timer = $Timer


func _ready() -> void:
	if not Engine.editor_hint:
		$Sprite.hide()
	else:
		timer.start()
	set_enemy_type(enemy_type)

func _process(_delta) -> void:
	if not Engine.editor_hint:
		return
	update()

func _draw() -> void:
	if Engine.editor_hint:
		var time2angle = TAU * (1 - timer.time_left / timer.wait_time)
		DrawUtil.draw_circle_arc(self, Vector2.ZERO, 24, 0, time2angle, Color.red)
		update()


func _editor_update_sprite() -> void:
	var enemy_texture = EditorUtil.find_scene_property_value(enemy_pckd, "texture")
	$Sprite.texture = enemy_texture


func _on_Timer_timeout() -> void:
	if Engine.editor_hint:
		return # don't actually spawn enemies in the editor

	var enemy = enemy_pckd.instance() as Node2D
	enemy.position = position
	var parent = get_parent()
	if parent:
		parent.add_child(enemy)
	else:
		self.add_child(enemy)


func set_enemy_type(new_type) -> void:
	enemy_type = new_type
	var enemy_data = BeasTiary.get_enemy_data(enemy_type)
	enemy_pckd = enemy_data.get_packed_scene()

	if Engine.editor_hint:
		_editor_update_sprite()

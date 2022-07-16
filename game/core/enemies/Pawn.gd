extends "res://game/enemies/enemytemplate.gd"

onready var tween = $Tween;

func _ready():
	set_health(2);


func _on_Timer_timeout():
	move_tile(2, self);

func translated(w : int, h : int) -> void:
	var dir = Vector2(w, h);
	tween.interpolate_property(self, "position", position, position + dir, 1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT);
	tween.start();
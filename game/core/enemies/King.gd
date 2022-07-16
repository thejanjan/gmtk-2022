extends "res://game/core/enemies/enemytemplate.gd"

onready var tween = $Tween;

func _ready():
	set_health(20);
	randomize()

func _on_Timer_timeout():
	move_tile(randi() % 8, self);

func translated(w : int, h : int) -> void:
	var dir = Vector2(w, h);
	tween.interpolate_property(self, "position", self.position, self.position + dir, 1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT);
	tween.start();

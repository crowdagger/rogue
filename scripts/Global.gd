extends Node

signal variable_updated

@export var hp_max:int = 3
var hp := hp_max:
	set(v):
		hp = clamp(v, 0, hp_max)
		variable_updated.emit()
var coins := 0:
	set(v):
		coins = v
		variable_updated.emit()
		
		
func reset():
	hp = hp_max
	coins = 0
	get_tree().reload_current_scene()

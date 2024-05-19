extends Node

signal variable_updated

@onready var music = $Music

var paused := false

func _physics_process(delta):
	if Input.is_action_just_pressed("pause"):
		if not paused:
			paused = true
			Engine.time_scale = 0.0
			music.playing = false
		else:
			paused = false
			Engine.time_scale = 1.0
			music.playing = true


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

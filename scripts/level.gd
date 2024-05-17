extends Node2D
@onready var cam = $CharacterBody2D/Camera2D

func _ready():
	$PostProcess/ColorRect.material.set("shader_parameter/size", 0.0)

	pass
	
func _on_character_body_2d_player_died():
	var tween = get_tree().create_tween()
	var tween2 = get_tree().create_tween()
	
	$PostProcess/AnimationPlayer.play("shockwave")
	tween2.tween_property(self, "modulate", Color(1.0, 0.0, 0.0), 0.5)
	tween.tween_property(cam, "zoom", Vector2(2.0,2.0), 1)
	

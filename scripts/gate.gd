extends Node2D

@export var next_scene: String

@onready var transition = $Transition


func _on_area_2d_body_entered(body):
	transition.change_scene(next_scene)

extends Area2D

@onready var timer = $Timer


func _on_body_entered(body):
	Engine.time_scale = 0.5
	body.get_node("AnimatedSprite2D").flip_v = true
	body.get_node("CollisionShape2D").queue_free()
	timer.start()
	body.death()


func _on_timer_timeout():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()

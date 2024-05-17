extends Area2D
@onready var sprite = $AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var audio = $AudioStreamPlayer2D
@onready var timer = $Timer

 
func _on_body_entered(_body):
	Global.coins += 1
	sprite.visible = false
	audio.playing = true
	collision.queue_free()
	timer.start()


	

func _on_timer_timeout():
	queue_free()

extends Area2D


 
func _on_body_entered(_body):
	Global.coins += 1
	queue_free()

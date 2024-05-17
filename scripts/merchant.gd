extends Area2D

@onready var bubble = $Bubble
@onready var coin_sprite = $CoinSprite


func _on_body_entered(body):
	if Global.coins >= 10:
		body.has_whip = true
		Global.coins  -= 10
		coin_sprite.queue_free()
		bubble.play("done")

extends CharacterBody2D

@export var hp:int = 3
@onready var collision = $CollisionShape2D
@onready var sprite = $AnimatedSprite2D

@onready var timer = $Invulnerability

var vulnerable = true

# Called when taking damage
func get_hit(dmg: int):
	if vulnerable:
		sprite.modulate = Color(1.0, 1.0, 1.0, 0.5)
		vulnerable = false
		timer.start()
		hp -= dmg
		if hp <= 0:
			die()

# Called at death
func die():
	collision.disabled = true
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color(1.0, 0, 0, 0.0), 1)
	tween.tween_callback(queue_free)



func _on_invulnerability_timeout():
	sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	vulnerable = true

extends AnimatableBody2D

@onready var sprite = $AnimatedSprite2D
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var collision = $CollisionShape2D
@export var open_left: bool = true
@export var open_right: bool = true 
@export var open_forever: bool = false

var open := false
var old_light_mask: int = 0


func _process(_delta):
	var detect_left: bool = ray_cast_left.is_colliding() and open_left
	var detect_right: bool = ray_cast_right.is_colliding() and open_right
	if detect_left or detect_right:
		if not open: 
			# Only disable shadow if it’s open forever as I only foun
			# How to do it permanently 
			if open_forever:
				$LightOccluder2D.queue_free()
			open = true
			sprite.play("open")
			collision.disabled = true
	else:
		if open and not open_forever: 
			open = false
			sprite.play("closed")
			collision.disabled = false

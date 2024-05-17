extends CharacterBody2D


const SPEED := 200.0
# Reverse of inertia
const ACCELERATION := 1.0
const JUMP_VELOCITY := -150.0
const JUMP_BOOST := -10.0
const JUMP_ROTATION := 10.0
const BOUNCE := 20.0
const JUMP_TICK := 0.02
const MAX_JUMP_TICKS := 8

var rotating := false
var hitting := false
var can_hit := true
var vulnerable := true
var can_jump := true
var since_jump_start := 0.0
var has_whip := false


@onready var death_timer = $DeathTimer

@onready var game_over = $GameOver

@onready var hitbox_l = $Whip/HitBoxLeft
@onready var hitbox_r = $Whip/HitBoxRight

@onready var sprite = $AnimatedSprite2D
@onready var timer = $HitDelay


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal player_died

func death():
	Engine.time_scale = 0.5
	sprite.flip_v = true
	self.get_node("CollisionShape2D").queue_free()
	game_over.playing = true
	death_timer.start()
	player_died.emit()
	
func fall(delta: float):
	velocity.y += gravity * delta
	if not hitting:
		sprite.play("idle")
		if rotating:
			sprite.rotation += JUMP_ROTATION * delta
			if sprite.rotation >= 360.0:
				sprite.rotation = 0.0
#
	
func hit():
	can_hit = false
	rotating = false
	sprite.rotation = 0
	sprite.play("hit")
	hitting = true
	if sprite.flip_h:
		hitbox_l.disabled = false
	else:
		hitbox_r.disabled = false
	timer.start()


func _physics_process(delta):
	if Input.is_action_just_released("jump"):
		since_jump_start = 0.0
		can_jump = true
	
		# Hit
	if Input.is_action_pressed("hit") and can_hit and has_whip:
		hit()
		
	# Add some boom to the jump if key is holded
	if Input.is_action_pressed("jump") and not can_jump:
		since_jump_start += delta
		var n = int(since_jump_start / JUMP_TICK)
		if n < MAX_JUMP_TICKS:
			velocity.y = JUMP_VELOCITY + JUMP_BOOST * n
		print(n)
	
	# Add the gravity.
	if not is_on_floor():
		fall(delta)
	else: 	# We are on ground 
		rotating = false
		sprite.rotation = move_toward(sprite.rotation, 0, JUMP_ROTATION)
	if not hitting: 
		# Handle jump
		if Input.is_action_pressed("jump") and is_on_floor() and can_jump:
			can_jump = false
			rotating = true
			velocity.y += JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			sprite.play("run")
			if direction < 0:
				sprite.flip_h = true
			else:
				sprite.flip_h = false
			velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION*SPEED)
		else:
			sprite.play("idle")
			velocity.x = move_toward(velocity.x, 0, ACCELERATION*SPEED)

	move_and_slide()
 


func _on_hit_delay_timeout():
	hitting = false
	hitbox_l.disabled = true
	hitbox_r.disabled = true
	$HitRecovery.start()
	


func _on_whip_body_entered(body):
	if "get_hit" in body:
		$AudioStreamPlayer2D.playing = true
		body.get_hit(3)
	print("Whipping")
	print(body)


func _on_hit_recovery_timeout():
	can_hit = true
	
func get_hit(dmg: int, from:Vector2):
	if vulnerable:
		var direction = position - from
		if abs(direction.x) > abs(direction.y):
			direction.y = 0.0
		if abs(direction.y) > abs(direction.x):
			direction.x = 0.0
		direction = direction.normalized()
		direction = direction * BOUNCE 
		print(direction)
		var x  = move_and_collide(direction)
		print(x)
		Global.hp -= dmg
		if Global.hp <= 0:
			death()
		else:
			vulnerable = false
			$Invulnerability.start()
			sprite.modulate = Color(1.0, .5, .5, 0.5)



func _on_invulnerability_timeout():
	vulnerable = true
	sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	pass # Replace with function body.


func _on_death_timeout():
	Engine.time_scale = 1.0
	Global.reset()

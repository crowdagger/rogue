extends CharacterBody2D


const SPEED := 200.0
# Reverse of inertia
const ACCELERATION := 1.0
const JUMP_VELOCITY := -250.0
const JUMP_ROTATION := 10.0

var rotating := false
var hitting := false

@onready var sprite = $AnimatedSprite2D
@onready var timer = $HitDelay


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal player_died

func death():
	player_died.emit()
	

func _physics_process(delta):
		# Hit
	if Input.is_action_pressed("hit"):
		rotating = false
		sprite.rotation = 0
		print("hit")
		sprite.play("hit")
		hitting = true
		timer.start()

	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if not hitting:
			sprite.play("idle")
			if rotating:
				sprite.rotation += JUMP_ROTATION * delta
				if sprite.rotation >= 360.0:
					sprite.rotation = 0.0 
	else: 	# We are on ground 
		rotating = false
		sprite.rotation = move_toward(sprite.rotation, 0, JUMP_ROTATION)



	if not hitting: 
		# Handle jump
		if Input.is_action_just_pressed("jump") and is_on_floor():
			rotating = true
			velocity.y = JUMP_VELOCITY

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
	# TODO: calculate hitbox and actually hit enemy

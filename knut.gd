extends CharacterBody2D


const SPEED = 60.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var horizontal_direction := Input.get_axis("left", "right")
	if horizontal_direction:
		velocity.x = horizontal_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	var vertical_direction := Input.get_axis("up", "down")
	if vertical_direction:
		velocity.y = vertical_direction * SPEED
	else:
		velocity.y = move_toward(velocity.x, 0, SPEED)	

	move_and_slide()
	
func _process(delta):
		if Input.is_action_just_pressed("left"):
			rotation_degrees = -90
		elif Input.is_action_just_pressed("right"):
			rotation_degrees = 90
		elif Input.is_action_just_pressed("up"):
			rotation_degrees = 0
		elif Input.is_action_just_pressed("down"):
			rotation_degrees = 180
			
		if velocity.y == 0 && velocity.x == 0:
			$CollisionShape2D/AnimatedSprite2D.animation = "Standing"
		else:
			$CollisionShape2D/AnimatedSprite2D.animation = "Walking"
	
	
	

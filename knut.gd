extends CharacterBody2D


const SPEED = 60.0
var food_need := 100
# 100 of any means death
var toxin_levels: Dictionary[String, int] = {a = 0, b = 0, c = 0, d = 0}


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
	
		%FoodNeedValue.text = str(food_need)
		
	


func _on_food_need_timer_timeout() -> void:
	food_need -= 5
	if food_need <= 0:
		get_tree().quit()
		
func increase_toxin_level(key: String, value: int):
	assert(value >= 0, "increase_toxin_level expects non-negative value")
	assert(toxin_levels.has(key))
	toxin_levels[key] += max(value, 0)
	%ToxinLevelValue.text = str(toxin_levels)
	
	if toxin_levels[key] >= 100:
		get_tree().quit()

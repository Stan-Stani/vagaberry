extends CharacterBody2D


const SPEED = 60.0
var food_level := 100.0
# 100 of any means death
var toxin_levels: Dictionary[String, float] = {a = 0, b = 0, c = 0, d = 0}

var energy := 100.0
var are_controls_enabled := true

func _physics_process(delta: float) -> void:
	
	var speed_multiplier = 1
	
	if energy <= 33.33:
		speed_multiplier = 0.5
		
		if energy <= 0:
			food_level -= 15
			energy = 100
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if are_controls_enabled:
		var horizontal_direction := Input.get_axis("left", "right")
		if horizontal_direction:
			velocity.x = horizontal_direction * SPEED * speed_multiplier
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * speed_multiplier)
			
		var vertical_direction := Input.get_axis("up", "down")
		if vertical_direction:
			velocity.y = vertical_direction * SPEED * speed_multiplier
		else:
			velocity.y = move_toward(velocity.x, 0, SPEED * speed_multiplier)	

		move_and_slide()
	


func _process(delta):
	if are_controls_enabled == true:
		if Input.is_action_just_pressed("left"):
			rotation_degrees = -90
		elif Input.is_action_just_pressed("right"):
			rotation_degrees = 90
		elif Input.is_action_just_pressed("up"):
			rotation_degrees = 0
		elif Input.is_action_just_pressed("down"):
			rotation_degrees = 180
			
	prints('vom', started_vomiting_time)
	if started_vomiting_time == null:
		if velocity.y == 0 && velocity.x == 0:
			$CollisionShape2D/AnimatedSprite2D.animation = "Standing"
		else:
			$CollisionShape2D/AnimatedSprite2D.play("Walking")

	%FoodNeedValue.text = str(food_level)
		
	

var started_vomiting_time = null
# Ideas
# buffs and debuffs depending on where slept
# like valheim
func _on_vitals_timeout() -> void:
	food_level -= 10
	if food_level <= 0:
		get_tree().quit()
	
	for key in toxin_levels:
		if toxin_levels[key] > 0:
			toxin_levels[key] -= 0.5
			%ToxinLevelValue.text = str(toxin_levels)
			
	energy  -= 2
	%EnergyLevelLabel.text = str(energy)
	
	prints(position.x /16, position.y / 16)
	
	if typeof(started_vomiting_time) == TYPE_FLOAT \
	&& Time.get_unix_time_from_system() - started_vomiting_time >= 2:
			started_vomiting_time = null
			are_controls_enabled = true
	
		 	
		
		
func increase_toxin_level(key: String, value: float):
	assert(value >= 0, "increase_toxin_level expects non-negative value")
	assert(toxin_levels.has(key))
	toxin_levels[key] += max(value, 0)
	%ToxinLevelValue.text = str(toxin_levels)
	
	if toxin_levels[key] >= 100:
		food_level -= 20
		toxin_levels[key] /= 2
		started_vomiting_time = Time.get_unix_time_from_system() 
		$CollisionShape2D/AnimatedSprite2D.play("Vomit")
		are_controls_enabled = false
		
func increase_food_level(value: float):
	assert(value >= 0, "increase_food_level expects non-negative value")
	var safe_food_change = clamp(value, 0, 100 - food_level)
	food_level += safe_food_change
	

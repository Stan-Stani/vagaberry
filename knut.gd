extends CharacterBody2D


const SPEED = 60.0
var food_level := 100.0
# 100 of any means death
var toxin_levels: Dictionary[String, float] = {a = 0, b = 0, c = 0, d = 0}
var toxin_colors_dict: Dictionary[String, String] = {a = "#d04648", b = "#30346d", c ="#d2aa99", d = "#6dc2ca"}
var vomit_animation_by_toxin: Dictionary[String, String] = {a = "VomitA", b = "VomitB", c = "VomitC", d = "VomitD"}
# meh, devil, gorge, bad
var toxin_dose: Dictionary[String, float] = {a = 66, b = 40, c = 80, d = 80}

var times_vomited := 0 

var energy := 100.0
var are_controls_enabled := true

var	horizontal_direction := 0.0
var vertical_direction := 0.0
var control_just_pressed = null

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
		horizontal_direction = Input.get_axis("left", "right")
		vertical_direction = Input.get_axis("up", "down")
		print(vertical_direction, 'meow')
		
		if horizontal_direction && control_just_pressed == "left" || control_just_pressed == "right":
			velocity.x = horizontal_direction * SPEED * speed_multiplier
			velocity.y = 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * speed_multiplier)
		if vertical_direction && control_just_pressed == "up" || control_just_pressed == "down":
			velocity.y = vertical_direction * SPEED * speed_multiplier
			velocity.x = 0
		else:
			velocity.y = move_toward(velocity.x, 0, SPEED * speed_multiplier)	

		move_and_slide()
	


func _process(delta):
	if are_controls_enabled == true:
		
		if Input.is_action_just_pressed("up"):
			control_just_pressed = "up"
		if Input.is_action_just_pressed("right"):
			control_just_pressed = "right"
		if Input.is_action_just_pressed("down"):
			control_just_pressed = "down"
		if Input.is_action_just_pressed("left"):
			control_just_pressed = "left"
		
		
		if velocity.x < 0:
			rotation_degrees = -90
		elif velocity.x > 0:
			rotation_degrees = 90
		elif velocity.y < 0:
			rotation_degrees = 0
		elif velocity.y > 0:
			rotation_degrees = 180
	if started_vomiting_time == null:
		if velocity.y == 0 && velocity.x == 0:
			$CollisionShape2D/AnimatedSprite2D.animation = "Standing"
		else:
			$CollisionShape2D/AnimatedSprite2D.play("Walking")

	%FoodNeedValue.text = str(int(food_level))
	

var started_vomiting_time = null
# Ideas
# buffs and debuffs depending on where slept
# like valheim
func _on_vitals_timeout() -> void:
	%DistanceValue.text = str(int(position.x))
	
	food_level -= 7.5
	if food_level <= 0:
		%EndScreen.visible = true
		%PlayAgainButton.grab_focus()
	
	for key in toxin_levels:
		if toxin_levels[key] > 0:
			toxin_levels[key] -= 2
			%ToxinLevelValue.text = str(toxin_levels)
			if toxin_levels[key] >= 100 - toxin_dose[key]:
				var color_rect := ColorRect.new()
				color_rect.color = Color(toxin_colors_dict[key])
				color_rect.position = position + Vector2(randi_range(-6, 6), randi_range(-6, 6))
				color_rect.size = Vector2(2, 2)
				color_rect.z_index = 0
				get_tree().current_scene.add_child(color_rect)
	# energy  -= 2
	# %EnergyLevelLabel.text = str(energy)
	
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
		$CollisionShape2D/AnimatedSprite2D.play(vomit_animation_by_toxin[key])
		times_vomited += 1
		are_controls_enabled = false
		
func increase_food_level(value: float):
	assert(value >= 0, "increase_food_level expects non-negative value")
	var safe_food_change = clamp(value, 0, 100 - food_level)
	food_level += safe_food_change
	

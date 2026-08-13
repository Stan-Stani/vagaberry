@tool
extends Area2D

@export var toxin_value := 66
@export var food_value := 66
# @export var toxin_increase_per_digest_action := 10
# @export var toxin_decrease_per_digest_action := 20
		
@export var sprite_frame := 0:
	set(value):
		sprite_frame = value
		$CollisionShape2D/AnimatedSprite2D.frame = value
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
var player_inside := false

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true
	
func _on_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false

@onready var sprite = $CollisionShape2D/AnimatedSprite2D
# Called every frame. 'delta' is the elapsed time s
#  ince the previous frame.
func _process(_delta: float) -> void:
	if player_inside and Input.is_action_just_pressed("interact") && sprite.frame != 0:
		
		%Player.increase_food_level(food_value)
		%Player/VitalsTimer.start()
		
		var frame_to_toxin_array = [null, 'a', 'b', 'c', 'd']
		%Player.increase_toxin_level(frame_to_toxin_array[sprite.frame], toxin_value)
		
		sprite.frame = 0

		
		
	

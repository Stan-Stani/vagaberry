extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
var player_inside := false

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("YO")
		player_inside = true
	
func _on_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player_inside and Input.is_action_just_pressed("interact"):
		print("Interacted!")

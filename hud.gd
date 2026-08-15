extends PanelContainer

@onready var SecondOnesPlace = %SecondOnesPlace
@onready var SecondTensPlace = %SecondTensPlace
@onready var MinuteOnesPlace = %MinuteOnesPlace
@onready var MinuteTensPlace = %MinuteTensPlace
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_vitals_timer_timeout() -> void:
	#if _iterate(SecondOnesPlace) == 0:
		#if _iterate(SecondTensPlace) == 6:
			#SecondTensPlace.animation = '0'
			#if _iterate(MinuteOnesPlace) == 0:
				#_iterate(MinuteTensPlace)
	if _iterate(SecondOnesPlace, 'backward') == 9:
		if _iterate(SecondTensPlace, 'backward') == 9:
			SecondTensPlace.animation = '5'
			if _iterate(MinuteOnesPlace, 'backward') == 9:
				_iterate(MinuteTensPlace, 'backward')
	
	

func _iterate(sprite: AnimatedSprite2D, dir = 'forward') -> int:
	
	var digit = int(sprite.animation)
	var result = null
	if dir == 'forward':
		result = digit + 1
		if result < 9:
			sprite.animation = str(result)
		else:
			result = 0
			sprite.animation = str(result)
	else:
		result = digit - 1
		if result > -1:
			sprite.animation = str(result)
		else:
			result = 9
			sprite.animation = str(result)
		
		
	return result

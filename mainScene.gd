extends Node2D

@export var max_anger_count = 3
@export var current_anger_count= 0

@export var adding_velocity = 30
@export var max_velocity = 220
@export var back_acceleration = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	$ambient.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	apply_back_acceleration()

func increase_velocity():
		var vel_x = $"background".linear_velocity.x + adding_velocity
		if vel_x > max_velocity:
			vel_x = max_velocity
		$"background".linear_velocity = Vector2(vel_x, 0)

# back acceleration
func apply_back_acceleration():
	if $"background".linear_velocity.x < 0:
		$"background".linear_velocity.x = 0
	elif $"background".linear_velocity.x > 0:
		$"background".linear_velocity.x -= back_acceleration


func _on__stroke_on_water():
	increase_velocity()

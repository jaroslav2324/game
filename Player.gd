extends Node2D

@export var adding_velocity = 100
@export var max_velocity = 220
@export var back_acceleration = 45
var isLive = true

var input_enabled = false

# signal stroke_on_water
# signal pos(gamerX, gamerY)

# Called when the node enters the scene tree for the first time.
func _ready():
	var signal_bus = get_node("/root/Main/SignalBus")
	signal_bus.start_anim_end.connect(_on_end_start_anim_signal)
	$"Lodocknik/StrokeComplete".hide()
	$"Lodocknik/StrokeReady".hide()
	$"Lantern/light".hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if input_enabled:
		# switch light
		if Input.is_action_just_pressed("switch_light"):
			print_debug("switching light")
			if $"Lantern/light".is_visible():
				$"Lantern/light_off_sound".play()
				$"Lantern/light".hide()
			else:
				$"Lantern/light".show()
				$"Lantern/light_on_sound".play()
				$"Lantern/TimerZat".start()				
				
		if $"Lantern/light".is_visible():
			$"Lantern/light".play()
		
		$cat.play()
		# pos.emit(self.position.x, self.position.y)
		get_node("/root/Main/SignalBus").emit_signal("pos", self.position.x, self.position.y)
		
		
		if Input.is_action_just_pressed("stroke") and $StrokeTimer.is_stopped() and isLive:
			increase_velocity()
			# stroke_on_water.emit()
			get_node("/root/Main/SignalBus").emit_signal("stroke_on_water")
			play_veslo_sound()
			# set timer for continuous movement(hold space)
			$StrokeTimer.start()
			set_stroke_complete_texture()
			if $"Lodocknik/StrokeTimerSitting".is_stopped():
				$"Lodocknik/StrokeTimerSitting".start()


		# elif Input.is_action_just_released("stroke"):
			# $StrokeTimer.stop()
			
		if $"Lodocknik/StrokeTimerComplete".is_stopped() and $"Lodocknik/StrokeTimerReady".is_stopped() \
		and $"Lodocknik/StrokeTimerSitting".is_stopped(): 
			set_stroke_sitting_texture()
			
		apply_back_acceleration(delta)
	
		
func _on_end_start_anim_signal():
	input_enabled = true
		
func increase_velocity():
		var vel_x = self.linear_velocity.x + adding_velocity
		if vel_x > max_velocity:
			vel_x = max_velocity
		self.linear_velocity = Vector2(vel_x, 0)

# back acceleration
func apply_back_acceleration(delta):
	if self.linear_velocity.x < 0:
		self.linear_velocity.x = 0
	elif self.linear_velocity.x > 0:
		self.linear_velocity.x -= back_acceleration * delta


func _on_stroke_timer_timeout():
	# print_debug("stroke timer timeout")
	if not Input.is_action_pressed("stroke"):
		$StrokeTimer.stop()
		return
	increase_velocity()
	# stroke_on_water.emit()
	get_node("/root/Main/SignalBus").emit_signal("stroke_on_water")
	play_veslo_sound()
	
	
func play_veslo_sound():
	var p = randf()
	if p > 0.5:
		$veslo1player.play()
	else:
		$veslo2palyer.play()
	

func set_stroke_complete_texture():
	$"Lodocknik/StrokeComplete".show()
	$"Lodocknik/VesloComplete".show()
	$"Lodocknik/StrokeReady".hide()
	$"Lodocknik/VesloReady".hide()
	$"Lodocknik/StrokeSitting".hide()
	$"Lodocknik/VesloSitting".hide()
	
func set_stroke_ready_texture():
	$"Lodocknik/StrokeReady".show()
	$"Lodocknik/VesloReady".show()
	$"Lodocknik/StrokeComplete".hide()
	$"Lodocknik/VesloComplete".hide()
	$"Lodocknik/StrokeSitting".hide()
	$"Lodocknik/VesloSitting".hide()
	
func set_stroke_sitting_texture():
	$"Lodocknik/StrokeSitting".show()
	$"Lodocknik/VesloSitting".show()
	$"Lodocknik/StrokeReady".hide()
	$"Lodocknik/VesloReady".hide()
	$"Lodocknik/StrokeComplete".hide()
	$"Lodocknik/VesloComplete".hide()


func _on_stroke_timer_sitting_timeout():
	if not $StrokeTimer.is_stopped() and Input.is_action_pressed("stroke"):
		$"Lodocknik/StrokeTimerReady".start()
		set_stroke_sitting_texture()
	
func _on_stroke_timer_complete_timeout():
	if not $StrokeTimer.is_stopped():
		$"Lodocknik/StrokeTimerSitting".start()
		set_stroke_complete_texture()

func _on_stroke_timer_ready_timeout():
	if not $StrokeTimer.is_stopped():
		$"Lodocknik/StrokeTimerComplete".start()
		set_stroke_ready_texture()


func _on_timer_zat_timeout():
	print_debug("timerZat")
	$"Lantern/light_off_sound".play()
	$"Lantern/light".hide()

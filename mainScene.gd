extends Node2D

@export var max_anger_count = 3
@export var current_anger_count= 0

var monster = preload("res://Монстр.tscn")
var eye = preload("res://Глаз.tscn")

var prev_player_x = 0
var coeff_back_shifting = 0.7

var start_anim = true
# Called when the node enters the scene tree for the first time.
func _ready():
	
	$TimerFirstStroke.start()
	$TimerSecondStroke.start()
	$TimerMeow.start()
	$"Игрок".hide()
	$pirs.hide()
	$TimerStartCutscene.start()
	# get_node("/root/Main/SignalBus").stroke_on_water.connect(_on__stroke_on_water)
	# $ambient.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if start_anim:
		$StartCutscene.play()
	else:
		if not $TimerZoomOut.is_stopped():
			# zoom out camera
			$"Игрок/Camera2D".zoom.x -= 58 * delta / 1000
			$"Игрок/Camera2D".zoom.y -= 58 * delta / 1000
			$"Игрок/Camera2D".position.x += 10 * delta * 2000 / 1000
			
		var player_x = $"Игрок".position.x
		$background.position.x += (player_x - prev_player_x) * coeff_back_shifting
		prev_player_x = player_x
	# apply_back_acceleration()

# func _on__stroke_on_water():
	# print_debug("stroke in main")
	# increase_velocity()


func _on_monster_create_trigger_body_entered(body):
	newMonstr()
	$MonsterCreateTrigger.queue_free()
	

func _on_monster_dead_trigger_area_entered(area):
	print_debug("trigger dead monstr")
	$sad_monster_sound.play()
	$monster.queue_free()
	$MonsterDeadTrigger.queue_free()


func _on_eye_create_trigger_area_entered(area):
	newEye()
	$EyeCreateTrigger.queue_free()


func _on_timer_start_cutscene_timeout():
	print_debug("start cutscene end")
	start_anim = false
	$ambient.play()
	$StartCutscene.stop()
	$StartCutscene.hide()
	$"Игрок".show()
	$pirs.show()
	$TimerZoomOut.start()
	$SignalBus.emit_signal("start_anim_end")


func _on_timer_first_stroke_timeout():
	$stroke.play()


func _on_timer_second_stroke_timeout():
	$stroke.play()


func _on_timer_meow_timeout():
	$meow.play()

func newMonstr():
	#spawn monster
	print_debug("trigger create monstr")
	var monsterInst = monster.instantiate()
	var player = get_node("Игрок")
	monsterInst.position.x = player.position.x - 700
	# print_debug(monsterInst.position.x - player.position.x)
	add_child(monsterInst)
	var monNode = get_node("Монстр")
	# $SignalBus.connect("stroke_on_water", monNode, "_on__stroke_on_water")
	


func newEye():
	print_debug("trigger create eye")
	var eyeInst = eye.instantiate()
	var player = get_node("Игрок")
	eyeInst.position.x = player.position.x + 900
	add_child(eyeInst)

func _on_ect_2_area_entered(area):
	newEye()
	$ECT2.queue_free()


func _on_ect_3_area_entered(area):
	newEye()
	$ECT3.queue_free() # Replace with function body.


func _on_ect_4_area_entered(area):
	newEye()
	$ECT4.queue_free() # Replace with function body.


func _on_ect_5_area_entered(area):
	newEye()
	$ECT5.queue_free() # Replace with function body.


func _on_ect_6_area_entered(area):
	newEye()
	$ECT6.queue_free() # Replace with function body.


func _on_ect_7_area_entered(area):
	newEye()
	$ECT7.queue_free() # Replace with function body.

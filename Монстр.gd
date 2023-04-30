extends RigidBody2D
var anger = 0
var maxAnger = 5
var hit_bit = true
@export var monsterSpeed = 100
var acceleration = 1
var beginPos = false
var isBegin = false


func _ready():
	#self.position.x = -1000
	var sig_bus = get_node("/root/Main/SignalBus")
	sig_bus.stroke_on_water.connect(_on__stroke_on_water)
	self.position.y = 0
	$monster/TimerBegin.start()
	$monster/plovnik.play()
	$monster/TimerPlavnikov.start()	
	$monster/rev.play()
	

func _process(delta):
	if isBegin:
		monsterInGame()
		self.linear_velocity = Vector2(monsterSpeed*acceleration,0)	
		$monster/AnimatedSprite2D.play("fly")
		# $monster/Label.text = "hit bit:" + str(hit_bit) + " anger:" + str(anger)
		if anger >= maxAnger:
			anger = -1000
			caught()


func caught():
	$monster/rev.play()
	$monster/TimerReva.start()
	monsterSpeed = 0
	

func _on__stroke_on_water():
	print_debug("anger", anger)
	if !hit_bit and isBegin: 
		anger += 1



func _on_timer_plavnikov_timeout():
	print_debug("aaaaa")
	if hit_bit:
		hit_bit = false
	else:
		$monster/plovnik.play()
		hit_bit = true
	



func _on_timer_anger_timeout():
	if anger > 0: anger -= 1


func _on_timer_reva_timeout():
	get_tree().paused = true 


func _on_monster_area_entered(area):
	print_debug("monster coutch you")
	caught()



func monsterInGame():
	var player = get_node("/root/Main/Игрок")
	#print_debug("begin pos", beginPos)
	#print_debug("is begin", isBegin)
	if beginPos:
		#print_debug("yes i do begPos")
		beginPos = false
		self.position.x = player.position.x - 1000
		isBegin = true
	
	if isBegin:
		if player.position.x - self.position.x < 400:
			acceleration = 0.5
		if player.position.x - self.position.x > 600:
			acceleration = 1.5
		if player.position.x - self.position.x > 1000:
			self.position.x = player.position.x - 600
		#print_debug(player.position.x - self.position.x)

func _on_timer_begin_timeout():
	print_debug("begin pos", beginPos)
	beginPos = true
	$monster/TimerAnger.start()
	monsterInGame()
	

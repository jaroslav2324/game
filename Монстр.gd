extends RigidBody2D
var anger = 0
var maxAnger = 5
var hit_bit = true
@export var monsterSpeed = 100
var acceleration = 1
var beginPos = false
var isBegin = false


func _ready():
	self.position.x = -1000
	self.position.y = 0
	$monster/TimerBegin.start()
	$monster/plovnik.play()
	$monster/TimerPlavnikov.start()	
	

func _process(delta):
	if isBegin:
		self.linear_velocity = Vector2(monsterSpeed*acceleration,0)	
		$monster/AnimatedSprite2D.play("fly")
		$monster/Label.text = "hit bit:" + str(hit_bit) + " anger:" + str(anger)
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
	caught()



func _on__pos(gamerX, gamerY):
	if beginPos:
		beginPos = false
		self.position.x = gamerX - 1000
		isBegin = true
	
	if isBegin:
		if gamerX - self.position.x < 400:
			acceleration = 0.5
		if gamerX - self.position.x > 600:
			acceleration = 1.5
		if gamerX - self.position.x > 1000:
			self.position.x = gamerX - 600
		#print_debug(gamerX - self.position.x)



func _on_timer_begin_timeout():
	print_debug(beginPos)
	beginPos = true
	$monster/TimerAnger.start()

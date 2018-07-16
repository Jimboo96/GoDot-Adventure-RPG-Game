extends KinematicBody2D

signal attacked
signal dead
signal prize

var target #player when enter zone
#load sprite
var trollSprite = load("res://scenes/enemy/Sprite/trollSprite.tscn")
var troll = trollSprite.instance()
var elfSprite = load("res://scenes/enemy/Sprite/elfSprite.tscn")
var elf = elfSprite.instance()
var zombieSprite = load("res://scenes/enemy/Sprite/zombieSprite.tscn")
var zombie = zombieSprite.instance()

var enemies_type = ["troll", "elf", "zombie"]
var type 
var movable = false
var attackable = false
var enemy

#enemy index
var HP
var DAME
var DEF

var attacked = false
var dead = false

var detect_distance = 200

const EXP = 60

func _ready():
	randomize() # for random choosing sprite
	set_physics_process(true)
	hide()
	init()
	appear()
	conn_signals()
	pass
	
#set init value for enemy
func init():
	var random_index = floor(rand_range(0, 3))
	type = enemies_type[random_index]
	match type:
		"troll": 
			add_child(troll)
			HP = 100
			DEF = 5
			DAME = 15
			movable = false
			attackable = true
			enemy = troll
			pass
		"elf": 
			add_child(elf)
			HP = 100
			DEF = 0
			DAME = 20
			movable = false
			attackable = true
			enemy = elf
			pass
		"zombie": 
			add_child(zombie)
			HP = 100
			DEF = 5
			DAME = 0
			movable = false
			attackable = false
			enemy = zombie
			pass
	pass
	
func appear():
	show()
	enemy.animation = "idle"
	enemy.play()
	$FlipTimer.start()
	pass

func conn_signals():
	#detect
	$Area2D.connect("body_entered", self, "target_enter")
	$Area2D.connect("body_exited", self, "target_exit")
	$lifeBarContainer.connect("monster_dead", self, "dead") #when HP = 0, dead
	$prize/hideTimer.connect("timeout", self, "enemy_disappear")
	$prize.connect("get_prize", self, "prize")
	#timer
	$FlipTimer.connect("timeout", self, "FlipTimer_timeout")
	$HurtTimer.connect("timeout", self, "HurtTimer_timeout")
	$DeadTimer.connect("timeout", self, "DeadTimer_timeout")
	pass
	
func target_enter(body):
	if !target:
		target = body
	$lifeBarContainer.show_bar()
	aim(target)
		
func target_exit(body):
	if target:
		target = null
		
	$lifeBarContainer.hide_bar()
	
	if $FlipTimer.is_paused():
		$FlipTimer.set_paused(false)
		
func _physics_process(delta):
	update()
	if target:
		aim(target)
	pass
	
func aim(x):
	if dead == true or attacked == true:
		return
		
	var direction_vector = (global.get_global_pos_of(x) - global.get_global_pos_of(self)).normalized()
	var self_facing = get_view_direction( global.get_global_pos_of( self ) )
	var angle = rad2deg(acos(direction_vector.dot(self_facing.normalized())))
	if angle <= 90: #if player is in FOV, if not flip side till player come near.
		$FlipTimer.set_paused(true)
			
	pass
		
func FlipTimer_timeout():
	if enemy.flip_h == true:
		enemy.flip_h = false
	else:
		enemy.flip_h = true
	pass
	
func HurtTimer_timeout():
	enemy.animation = "idle"
	pass

func DeadTimer_timeout():
	enemy.stop()
	$prize.appear()
	enemy_disable()
	pass
	
func dead():
	dead = true
	enemy.animation = "die"
	$DeadTimer.start()
	$CollisionShape2D.queue_free()
	$Area2D/detectZone.queue_free()
	emit_signal("dead", EXP)
	pass
	
func enemy_disable():
	enemy.hide()
	$lifeBarContainer.hide()
	pass
	
func enemy_disappear():
	queue_free()
	
func attacked(dame):
	enemy.animation = "hurt"
	var dame_received = dame - DEF
	if dame_received <= 0: 
		return
	#emit only when dame_received > 0
	attacked = true
	$lifeBarContainer.attacked(dame_received)
	$HurtTimer.start()
	pass

func prize(prize_type, value):
	print("prize enemy called")
	emit_signal("prize", prize_type, value)

func get_view_direction(dir = Vector2()):
	if enemy.flip_h == false:
		return  global.cartesian_to_isometric( Vector2( dir.y , dir.x * (-1) ) )
	else:
		return  global.cartesian_to_isometric( Vector2( dir.y * (-1), dir.x ) )
	pass
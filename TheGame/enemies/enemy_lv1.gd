extends KinematicBody2D

signal attacked
signal dead
signal prize

#load sprite
#var trollSprite = load("res://enemies/Sprite/BigTrollSprite.tscn")
#var elfSprite = load("res://enemies/Sprite/elfSprite.tscn")
#var zombieSprite = load("res://enemies/Sprite/zombieSprite.tscn")
#var zombie = zombieSprite.instance()

var enemies_type = ["trollBrown", "troll", "zombie"]
var type 
var movable = false
var attackable = false
var enemySprite
var target
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
	init()
	#appear()
	conn_signals()
	pass
	
#set init value for enemyp
func init():
	var random_index = floor(rand_range(0, 3))
	type = enemies_type[random_index]
	match type:
		"trollBrown":
			var trollBrown = preload("res://enemies/Sprite/trollBrownSprite.tscn").instance()
			add_child(trollBrown)
			trollBrown.set_name("enemySprite")
			HP = 100
			DEF = 5
			DAME = 15
			movable = false
			attackable = true
			#enemySprite = troll
			pass
		"troll": 
			var troll = preload("res://enemies/Sprite/trollSprite.tscn").instance()
			add_child(troll)
			troll.set_name("enemySprite")
			HP = 100
			DEF = 0
			DAME = 20
			movable = false
			attackable = true
			#enemySprite = elf
			pass
		"zombie": 
			var zombie = preload("res://enemies/Sprite/zombieSprite.tscn").instance()
			add_child(zombie)
			zombie.set_name("enemySprite")
			HP = 100
			DEF = 5
			DAME = 0
			movable = false
			attackable = false
			#enemySprite = zombie #set name for sprite
			pass
	pass
	
func appear():
	call_deferred("deferred_appear")

func deferred_appear():
	$enemySprite.animation = "idle"
	$enemySprite.play()
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
	if "player" in body.get_name():
		#print("%s enters from %s" % [body.get_name(), self.get_name()])
		target = body
		$FlipTimer.set_paused(true)
		$lifeBarContainer.show_bar()
		aim(target)
		#print(target.get_parent().get_name())
		#print(self.get_parent().get_name())
		
func target_exit(body):
	if "player" in body.get_name():
		#print("%s out from %s" % [body.get_name(), self.get_name()])
		target = null
		
		$lifeBarContainer.hide_bar()
		
		if $FlipTimer.is_paused():
			$FlipTimer.set_paused(false)
		
func _physics_process(delta):
	update()
	if target:
		aim(target)
	pass
	
func aim(target):
	#print(x)
	if dead == true or attacked == true:
		return
		
	var direction_vector = (get_global_pos_of(target) - get_global_pos_of(self)).normalized()
	var self_facing = get_view_direction( get_global_pos_of( self ) )
	$RayCast2D.set_cast_to(self_facing)
	var angle = rad2deg(acos(direction_vector.dot(self_facing.normalized())))
	if angle > 90: #if player is in FOV, if not flip side till player come near.
		if $enemySprite.flip_h == true:
			$enemySprite.flip_h = false
		else:
			$enemySprite.flip_h = true
	pass
		
func FlipTimer_timeout():
	if $enemySprite.flip_h == true:
		$enemySprite.flip_h = false
	else:
		$enemySprite.flip_h = true
	pass
	
func HurtTimer_timeout():
	$enemySprite.animation = "idle"
	pass

func DeadTimer_timeout():
	$enemySprite.stop()
	$prize.appear()
	enemy_disable()
	pass
	
func dead():
	dead = true
	$enemySprite.animation = "die"
	$DeadTimer.start()
	$CollisionShape2D.queue_free()
	$Area2D/detectZone.queue_free()
	emit_signal("dead", EXP, self)
	pass
	
func enemy_disable():
	$enemySprite.hide()
	$lifeBarContainer.hide()
	pass
	
func enemy_disappear():
	call_deferred("queue_free")
	
func attacked(dame):
	$enemySprite.animation = "hurt"
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
	if $enemySprite.flip_h == false:
		return  global.cartesian_to_isometric( Vector2( dir.y , dir.x * (-1) ) )
	else:
		return  global.cartesian_to_isometric( Vector2( dir.y * (-1), dir.x ) )
	pass
	
func get_global_pos_of(x):
	var pos =  ( x.position ) 
	#print("%s, %s" % [x.get_name(), pos])
	return pos
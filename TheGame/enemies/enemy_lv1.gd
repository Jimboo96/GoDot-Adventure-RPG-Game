extends KinematicBody2D

signal attacked
signal dead
signal prize

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
var SPEED

var attacked = false
var dead = false

var detectDistance = 200
var attackDistance = 80

var canAttack = true
var playerInZone = false

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
	$AttackIcon.hide()
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
			SPEED = 190
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
			SPEED = 200
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
			SPEED = 160
			movable = true
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
	$enemySprite.connect("animation_finished", self, "idle")
	#timer
	$FlipTimer.connect("timeout", self, "FlipTimer_timeout")
	$AttackWaitTime.connect("timeout", self, "AttackTimer_timeout")
	pass
	
func target_enter(body):
	if "player" in body.get_name():
		$AttackIcon.show()
		target = body
		$FlipTimer.set_paused(true)
		$lifeBarContainer.show_bar()
		aim(target)
		playerInZone = true
		
func target_exit(body):
	if "player" in body.get_name():
		$AttackIcon.hide()
		target = null
		playerInZone = false
		$lifeBarContainer.hide_bar()
		
		if $FlipTimer.is_paused():
			$FlipTimer.set_paused(false)
		
func _physics_process(delta):
	update()
	if target:
		if target.get_name() == "player":
			aim(target)
	pass
	
func aim(target):
	if dead == true:
		return
		
	var direction_vector = (get_global_pos_of(target) - get_global_pos_of(self)).normalized()
	var self_facing = get_view_direction( get_global_pos_of( self ) )
	var angle = rad2deg(acos(direction_vector.dot(self_facing.normalized())))
	if angle > 90: #if player is in FOV, if not flip side till player come near.
		if $enemySprite.flip_h == true:
			$enemySprite.flip_h = false
		else:
			$enemySprite.flip_h = true
			
	if angle <= 90:
		if target.position.distance_to(self.position) <= attackDistance:
			if attackable == true:
				if canAttack == true:
					attack(target)
					$AttackWaitTime.start()
					canAttack = false
		else:
			if movable == true:
				move_to_target(direction_vector)
	pass
		
func FlipTimer_timeout():
	if $enemySprite.flip_h == true:
		$enemySprite.flip_h = false
	else:
		$enemySprite.flip_h = true
	pass
	
func AttackTimer_timeout():
	canAttack = true
	
func idle():
	if $enemySprite.get("animation") == "hurt" or $enemySprite.get("animation") == "attack":
		$enemySprite.animation = "idle"
	if $enemySprite.get("animation") == "die":
		$enemySprite.stop()
		$prize.appear()
		enemy_disable()
	if playerInZone == false:
		$enemySprite.animation = "idle"
	pass

func attack(target):
	if target:
		$enemySprite.animation = "attack"
		target.attacked(DAME)
		
func move_to_target(direction):
	var motion = direction * SPEED
	move_and_slide(motion)
	$enemySprite.animation = "walk"
	
func dead():
	dead = true
	$FlipTimer.stop()
	$enemySprite.animation = "die"
	if has_node("Area2D/detectZone"):
		$Area2D/detectZone.disabled = true
	if has_node("CollisionShape2D"):
		$CollisionShape2D.disabled = true
	emit_signal("dead", EXP, self)
	pass
	
func enemy_disable():
	$Anim.play("dead")
	if $enemySprite.is_inside_tree():
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
	if get_tree().get_root().get_node("Main/Sound/Scream").playing:
		return
	get_tree().get_root().get_node("Main/Sound/Scream").play()
	pass

func prize(prize_type, value):
	emit_signal("prize", prize_type, value)

func get_view_direction(dir = Vector2()):
	var b = dir
	var a = Vector2(0, dir.y)
	var c = a - b
	if $enemySprite.flip_h == false:
		if dir.x < 0:
	      		return c
		else:
			return  -c
	else:
		if dir.x < 0:
			return -c
		else:
			return c
	pass
	
func get_global_pos_of(x):
	var pos = ( x.position ) 
	return pos
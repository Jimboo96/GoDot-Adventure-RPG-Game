extends KinematicBody2D

signal attack 
signal attacked

var HP = 100
var def = 10
var dmg = 60


var maxHP = 100

var motion = Vector2()
var WALK_SPEED = 400 # Pixels/second

var can_attack = false
var playerMovable
var cast_length
var detected_target

var SAnim 
var Sflip

#stat vars
var Str
var Agi
var constitution
var Wc
var Lvl

func _enter_tree():
	pass
	
func _ready():
	set_process_input(true)
	set_process(true)
	_load_stats()
	#init
	playerMovable = true
	cast_length = 60
	#connect signals
	$disappearTimer.connect("timeout", self, "_on_disappearTimer_timeout")
	$AttackRay.connect("body_entered", self, "enemy_in_zone")
	$AttackRay.connect("body_exited", self, "enemy_out_zone")
	
func appear(anim): #appear when added to area
	print("appear")
	show()
	playerMovable = true
	
func _input(event):
	if event.is_action_pressed("space"):
		flip_coin()
		
	if Input.is_action_pressed("attack"):
		if can_attack == true and detected_target:
			detected_target.attacked(dmg)
			print("enemy atteacked for: ", dmg, " damge")
	
func _physics_process(delta):
	get_input()
	move_and_slide(motion)
	update()
	print(motion)

func get_input():
	motion = Vector2()
	
	
	if playerMovable:
		if Input.is_action_pressed("move_up"):
			motion.y  -= 1
			$Sprite.animation = "walk"
			$Sprite.flip_h = false
			$AttackRay.position = Vector2(30,0)
			
		if Input.is_action_pressed("move_bottom"):
			motion.y += 1
			$Sprite.animation = "walk"
			$Sprite.flip_h = true
			$AttackRay.position = Vector2(-30,0)
			
		if Input.is_action_pressed("move_left"):
			motion.x -=1
			$Sprite.animation = "walk"
			$Sprite.flip_h = true
			$AttackRay.position = Vector2(-30,0)
			
		if Input.is_action_pressed("move_right"): 
			motion.x += 1
			$Sprite.animation = "walk"
			$Sprite.flip_h = false
			$AttackRay.position = Vector2(30,0)
			
		elif Input.is_action_pressed("attack"):
			$Sprite.animation = "attack"
			if get_tree().get_root().get_child(1).get_node("Sound/SwordSwing").playing == false:
				get_tree().get_root().get_child(1).get_node("Sound/SwordSwing").play()
			elif get_tree().get_root().get_child(1).get_node("Sound/SwordSwing").playing == true:
				pass
			
		elif motion == Vector2(0,0):
			$Sprite.animation = "idle"
			
			
	else:
		#$Sprite.animation = "idle"
		pass
	motion = motion.normalized() * WALK_SPEED
	if motion != Vector2(0,0):
			$Sprite.animation = "walk"

func enemy_in_zone(body):
	if "enemy" in body.get_name():
		var overlap = $AttackRay.get_overlapping_bodies()
		if overlap.size() > 0:
			for i in overlap.size():
				if "enemy" in overlap[i].get_name():
					detected_target = overlap[i]
					can_attack = true
					return
					
		
func enemy_out_zone(body):
	var e = 0
	if "enemy" in body.get_name():
		detected_target = null
		can_attack = false
		
# Flips a coin.
func flip_coin():
	get_tree().get_root().get_child(1).get_node("Sound/CoinFlip").play()
	_load_stats()
	var coinSide = randi()%2
	if(coinSide == 0):
		print("Kruuna")
	elif(coinSide == 1):
		print("Klaava")
		
# Stops player from moving when transistioning between areas.
func _on_MoveAreas_halt_player():
	playerMovable = false
	
# Return player position.
func get_player_pos():
	return position
	
#attacked by enemy
func attacked(damage):
	$Sprite.animation = "hurt"
	var damage_received = damage - def
	if damage_received > 0:
		emit_signal("attacked", damage_received)


func player_dead():
	$disappearTimer.start()
	$Sprite.animation = "die"

func _on_disappearTimer_timeout():
	queue_free()
	pass
	
func updateHP(newHP):
	HP = newHP
	

#called when level up
func level_up(Str, Agi, constitution, Wc):
	HP = 10 * constitution
	def = def * 3/2
	WALK_SPEED = WALK_SPEED * ((Agi/10)+1)
	dmg = (10 * Str) + 60
	print("damage: ", dmg, " Walk_speed: ", WALK_SPEED, "hp: ", HP)

func _load_stats():
	var current_line = global._load_player_stats(1)
	if current_line == null:
		pass
	else:
		Str = current_line["Str"]
		Agi = current_line["Agi"]
		constitution = current_line["Const"]
		Wc = current_line["Wc"]
		Lvl = global.player_lvl
		level_up(Str, Agi, constitution, Wc)
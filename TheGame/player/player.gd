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
var playerMovable = true
var cast_length
var detected_target

var animationToPlay = null
var directionFacing = null

var playerArmour = null
var isInteracting = false
var isCuttingWood = false
var ownsAxe = true

var inventoryScene

var sound
var swing
#stat vars
var Str
var Agi
var constitution
var Wc
var Lvl

func _enter_tree():
	if global.restartBool:
		printt("position is",position)
		position = Vector2(0,0)
		printt("and now it is",position)
	pass
	
func _ready():
	print(transform)
	
	set_process_input(true)
	set_process(true)
	_load_stats()
	#init
	cast_length = 60
	#connect signals
	$disappearTimer.connect("timeout", self, "_on_disappearTimer_timeout")
	$AttackRay.connect("body_entered", self, "enemy_in_zone")
	$AttackRay.connect("body_exited", self, "enemy_out_zone")
	#set player sprite
	set_player_sprite(playerArmour)
	
	sound = global.find_node_by_name(get_tree().get_root(), "Sound")
	swing = sound.get_node("SwordSwing")


func appear(anim): #appear when added to area
	playerMovable = true
	show()
	play_animation("spawning")
	if $CollisionShape2D.disabled == true:
		$CollisionShape2D.disabled = false
		$AttackRay/CollisionShape2D.disabled = false
	$AttackRay.set("monitoring", true)
	set_collision_layer_bit(2, true)
	
func temp_disable():
	playerMovable = false
	$CollisionShape2D.disabled = true
	$AttackRay/CollisionShape2D.disabled = true
	hide()
	$AttackRay.set("monitoring", false)
	set_collision_layer_bit(2, false)
	
func _input(event):
	if event.is_action_pressed("space"):
		flip_coin()
		random_armour()
		
	if Input.is_action_pressed("attack"):
		if can_attack == true and detected_target:
			detected_target.attacked(dmg)
			print("enemy atteacked for: ", dmg, " damge")
			
	if(event.is_action_pressed("inv_key")):
		get_tree().call_group("room","inventory_open")
		if playerMovable:
			playerMovable = false
		elif !playerMovable:
			playerMovable = true

	
func _physics_process(delta):
	get_input()
	move_and_slide(motion)
	update()
	#print(motion)

func get_input():
	motion = Vector2()
	
	if playerMovable:
		if Input.is_action_pressed("move_up"):
			motion.y  -= 1
			animationToPlay = "up"
			directionFacing = "Up"
			$AttackRay.position = Vector2(30,0)
			
		if Input.is_action_pressed("move_bottom"):
			motion.y += 1
			animationToPlay = "down"
			directionFacing = "Down"
			$AttackRay.position = Vector2(-30,0)
			
		if Input.is_action_pressed("move_left"):
			motion.x -=1
			animationToPlay = "left"
			directionFacing = "Left"
			$AttackRay.position = Vector2(-30,0)
			
		if Input.is_action_pressed("move_right"): 
			motion.x += 1
			animationToPlay = "right"
			directionFacing = "Right"
			$AttackRay.position = Vector2(30,0)
			
		elif Input.is_action_pressed("attack"):
			if can_attack == true and detected_target:
				detected_target.attacked(dmg)
				if directionFacing != null:
					animationToPlay = "attack" + directionFacing
					if swing.playing == false:
						swing.play()
					elif swing.playing == true:
						pass
				
		elif motion == Vector2(0,0):
			if directionFacing != null:
				animationToPlay = "standing" + directionFacing
		# play the animation
		play_animation(animationToPlay)
	else:
		pass #if player is not movable
	motion = motion.normalized() * WALK_SPEED
	#if motion != Vector2(0,0):
	#		$Sprite.animation = "walk"

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
	get_tree().get_root().get_node("Main/Sound/CoinFlip").play()
	_load_stats()
	var coinSide = randi()%2
	if(coinSide == 0):
		print("Heads")
	elif(coinSide == 1):
		print("Tails")

# Return player position.
func get_player_pos():
	return position

#attacked by enemy
func attacked(damage):
	#animationToPlay = "damaged"
	var damage_received = damage - def
	if damage_received > 0:
		emit_signal("attacked", damage_received)

func player_dead():
	$disappearTimer.start()
	animationToPlay = "dead"
	play_animation(animationToPlay)


func _on_disappearTimer_timeout():
	queue_free()
	pass

func updateHP(newHP):
	HP = newHP

func level_up(Str, Agi, constitution, Wc):
	HP = 10 * constitution 
	def = 10 * 3/2
	def += global.armorFromArmor
	WALK_SPEED = 400 * ((Agi/10)+1)
	dmg = (10 * Str) + 60
	dmg += global.damageFromWeapons
	#printt("damage:", dmg, " Walk_speed:", WALK_SPEED, "hp:", HP)


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
	print("stats are loaded ")
	printt("damage:", dmg, " Walk_speed:", WALK_SPEED, "hp:", HP)

func play_animation(var animation):
	if $PlayerSprite/AnimationPlayer.current_animation.get_basename() != animationToPlay:
		if animation != null:
			$PlayerSprite/AnimationPlayer.play(animation)
		
func stop_animation():
	if animationToPlay != null && $PlayerSprite/AnimationPlayer.is_playing():
		$PlayerSprite/AnimationPlayer.stop()

#set the player sprite according to the armour they are wearing.
func set_player_sprite(var armour):
	if armour != null:
		var fileName = "player_" + armour + "_armour"
		var playerSprite = $PlayerSprite
		var spriteFile = "res://assets/characters/player/" + fileName + ".png"
		if File.new().file_exists(spriteFile):
			var sprite = load(spriteFile) 
			playerSprite.texture = sprite
			
func random_armour():
	var randomNum = randi()%4 + 1
	if randomNum == 1:
		playerArmour = "iron"
	elif randomNum == 2:
		playerArmour = "gold"
	elif randomNum == 3:
		playerArmour = "chain"
	elif randomNum == 4:
		playerArmour = "leather"
	else:
		playerArmour = null
	set_player_sprite(playerArmour)

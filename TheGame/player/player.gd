extends KinematicBody2D

signal attack 
signal attacked

export (int) var HP = 100
export (int) var DEF = 10
export (int) var DAME = 60

var maxHP = 100

const WALK_SPEED = 400 # Pixels/second

var can_attack = false

var playerMovable = true
var detected_target

var animationToPlay = null
var directionFacing = null

var playerArmour = null
var isInteracting = false
var isCuttingWood = false
var ownsAxe = true

func _enter_tree():
	pass
	
func _ready():
	set_process_input(true)
	set_process(true)
	#init
	playerMovable = true
	DAME = 60
	#connect signals
	$disappearTimer.connect("timeout", self, "_on_disappearTimer_timeout")
	$AttackRay.connect("body_entered", self, "enemy_in_zone")
	$AttackRay.connect("body_exited", self, "enemy_out_zone")
	#set player sprite
	set_player_sprite(playerArmour)
	
func appear(anim): #appear when added to area
	show()
	play_animation("spawning")
	playerMovable = true
	
func _input(event):
	if playerMovable:
		if event.is_action_pressed("space"):
			flip_coin()
			#random_armour()
			
		if Input.is_action_pressed("move_up"):
			animationToPlay = "up"
			directionFacing = "Up"
			$AttackRay.position = Vector2(30,0)
			
		elif Input.is_action_pressed("move_bottom"):
			animationToPlay = "down"
			directionFacing = "Down"
			$AttackRay.position = Vector2(-30,0)
			
		elif Input.is_action_pressed("move_left"):
			animationToPlay = "left"
			directionFacing = "Left"
			$AttackRay.position = Vector2(-30,0)
			
		elif Input.is_action_pressed("move_right"): 
			animationToPlay = "right"
			directionFacing = "Right"
			$AttackRay.position = Vector2(30,0)
			
		elif Input.is_action_pressed("attack"):
			if can_attack == true and detected_target:
				detected_target.attacked(DAME)
				if directionFacing != null:
					animationToPlay = "attack" + directionFacing
			get_tree().get_root().get_node("Main/Sound/SwordSwing").play()
			
		else:
			if directionFacing != null:
				animationToPlay = "standing" + directionFacing
		play_animation(animationToPlay)
	else:
		if directionFacing != null && !isCuttingWood:
			animationToPlay = "standing" + directionFacing
		play_animation(animationToPlay)

func _physics_process(delta):
	if playerMovable:
		var motion = Vector2()
		if Input.is_action_pressed("move_up"):
			motion += Vector2(0,-1)
		elif Input.is_action_pressed("move_bottom"):
			motion += Vector2(0,1)
		elif Input.is_action_pressed("move_left"):
			motion += Vector2(-1,0)
		elif Input.is_action_pressed("move_right"): 
			motion += Vector2(1,0)
		else:
			motion = Vector2(0,0)
			
		motion = motion.normalized() * WALK_SPEED
		move_and_slide(motion)

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
	var damage_received = damage - DEF
	if damage_received > 0:
		emit_signal("attacked", damage_received)
		pass

func player_dead():
	$disappearTimer.start()
	animationToPlay = "dead"
	play_animation(animationToPlay)

func _on_disappearTimer_timeout():
	queue_free()
	pass

func updateHP(newHP):
	HP = newHP

#called when level up
func levelup():
	play_animation("victory")
	HP = maxHP * 3/2
	DEF = DEF * 3/2
	DAME = DAME + 10

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
		global.playerArmour = "iron"
	elif randomNum == 2:
		global.playerArmour = "gold"
	elif randomNum == 3:
		global.playerArmour = "chain"
	elif randomNum == 4:
		global.playerArmour = "leather"
	else:
		global.playerArmour = null
	set_player_sprite(global.playerArmour)
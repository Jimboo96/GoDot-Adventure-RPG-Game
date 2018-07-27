extends KinematicBody2D

signal attack 
signal attacked

export (int) var HP = 100
export (int) var DEF = 10
export (int) var DAME = 60

var maxHP = 100

const WALK_SPEED = 400 # Pixels/second

var can_attack = false
var playerMovable
var detected_target

var SAnim 
var Sflip

func _enter_tree():
	hide()
	pass
	
func _ready():
	set_process_input(true)
	set_process(true)
	#init
	#connect signals
	$disappearTimer.connect("timeout", self, "_on_disappearTimer_timeout")
	$AttackRay.connect("body_entered", self, "enemy_in_zone")
	$AttackRay.connect("body_exited", self, "enemy_out_zone")
	
func appear(anim): #appear when added to area
	show()
	playerMovable = true
	
func _input(event):
	if event.is_action_pressed("space"):
		flip_coin()
		
	if Input.is_action_just_pressed("attack"):
		if can_attack == true and detected_target:
			detected_target.attacked(DAME)
			
	
func _physics_process(delta):
	update()
	move_and_animation()
	
func move_and_animation():
	var motion = Vector2()

	if playerMovable:
		if Input.is_action_pressed("move_up"):
			motion += Vector2(0, -1)
			$Sprite.animation = "walk"
			$Sprite.flip_h = false
			$AttackRay.position = Vector2(30,0)
			
		elif Input.is_action_pressed("move_bottom"):
			motion += Vector2(0, 1)
			$Sprite.animation = "walk"
			$Sprite.flip_h = true
			$AttackRay.position = Vector2(-30,0)
			
		elif Input.is_action_pressed("move_left"):
			motion += Vector2(-1, 0)
			$Sprite.animation = "walk"
			$Sprite.flip_h = true
			$AttackRay.position = Vector2(-30,0)
			
		elif Input.is_action_pressed("move_right"): 
			motion += Vector2(1, 0)
			$Sprite.animation = "walk"
			$Sprite.flip_h = false
			$AttackRay.position = Vector2(30,0)
			
		elif Input.is_action_pressed("attack"):
			$Sprite.animation = "attack"
			if get_tree().get_root().get_node("Main/Sound/SwordSwing").playing == true:
				return
			get_tree().get_root().get_node("Main/Sound/SwordSwing").play()
			
		else:
			$Sprite.animation = "idle"
			pass
			
	else:
		$Sprite.animation = "idle"
	
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
	var damage_received = damage - DEF
	if damage_received > 0:
		emit_signal("attacked", damage_received)
		$Sprite.animation = "hurt"
		pass
		
func player_dead():
	$disappearTimer.start()
	$Sprite.animation = "die"

func _on_disappearTimer_timeout():
	queue_free()
	pass
	
func updateHP(newHP):
	HP = newHP
	
#called when level up
func levelup():
	HP = maxHP * 3/2
	DEF = DEF * 3/2
	DAME = DAME + 10
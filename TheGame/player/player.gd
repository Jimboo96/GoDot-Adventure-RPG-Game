extends KinematicBody2D

signal attack 
signal attacked

export (int) var HP = 100
export (int) var def = 10
export (int) var dame = 60

var maxHP = 100

const WALK_SPEED = 400 # Pixels/second

var can_attack = false
var playerMovable
var cast_length
var detected_target

var SAnim 
var Sflip

func _enter_tree():
	hide() #hide when enter tree
	pass
	
func _ready():
	set_process_input(true)
	#init
	playerMovable = true
	cast_length = 60
	dame = 60
	#connect signals
	$disappearTimer.connect("timeout", self, "_on_disappearTimer_timeout")
	$AttackRay.connect("body_entered", self, "enemy_in_zone")
	$AttackRay.connect("body_exited", self, "enemy_out_zone")
	
func appear(): #appear when added to area
	show()
	
func _input(event):
	if event.is_action_pressed("space"):
		flip_coin()
		
	if Input.is_action_pressed("attack"):
		if can_attack == true and detected_target:
			print("player attacks %s" % detected_target.get_name())
			detected_target.attacked(dame)
			

func _physics_process(delta):
	update()
	#moving
	move_and_animation(delta)
	
func move_and_animation(delta):
	var motion = Vector2()

	if playerMovable:
		if Input.is_action_pressed("move_up"):
			motion += Vector2(0, -1)
			$Sprite.animation = "walk"
			$Sprite.flip_h = false
			#$playerRayCast.set("cast_to", Vector2(cast_length,0))
			$AttackRay.position = Vector2(30,0)
			
		elif Input.is_action_pressed("move_bottom"):
			motion += Vector2(0, 1)
			$Sprite.animation = "walk"
			$Sprite.flip_h = true
			#$playerRayCast.set("cast_to", Vector2(cast_length * (-1) ,0))
			$AttackRay.position = Vector2(-30,0)
			
		elif Input.is_action_pressed("move_left"):
			motion += Vector2(-1, 0)
			$Sprite.animation = "walk"
			$Sprite.flip_h = true
			#$playerRayCast.set("cast_to", Vector2(cast_length * (-1),0))
			$AttackRay.position = Vector2(-30,0)
			
		elif Input.is_action_pressed("move_right"): 
			motion += Vector2(1, 0)
			$Sprite.animation = "walk"
			$Sprite.flip_h = false
			#$playerRayCast.set("cast_to", Vector2(cast_length,0))
			$AttackRay.position = Vector2(30,0)
			
		elif Input.is_action_pressed("attack"):
			$Sprite.animation = "attack"
			
		else:
			$Sprite.animation = "idle"
			pass
			
	else:
		$Sprite.animation = "idle"
	
	motion = motion.normalized() * WALK_SPEED
	motion = global.cartesian_to_isometric(motion)
	move_and_slide(motion)

func enemy_in_zone(body):
	if "enemy" in body.get_name():
		detected_target = body
		can_attack = true
		
func enemy_out_zone(body):
	if "enemy" in body.get_name():
		detected_target = null
		can_attack = false
		
# Flips a coin.
func flip_coin():
	get_tree().get_root().get_child(1).get_node("Sound/CoinFlip").play()
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
	print("player is attacked")
	var damage_received = damage - def
	if damage_received > 0:
		emit_signal("attacked", damage_received)
		
func player_dead():
	$disappearTimer.start()
	$Sprite.animation = "dead"

func _on_disappearTimer_timeout():
	queue_free()
	pass
	
func updateHP(newHP):
	HP = newHP
	
#called when level up
func levelup():
	HP = maxHP * 3/2
	def = def * 3/2
	dame = dame + 10
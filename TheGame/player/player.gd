extends KinematicBody2D

signal attack 
signal player_attacked

export (int) var HP = 100
export (int) var def = 10
export (int) var dame = 60

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
	cast_length = 40
	dame = 60
	#connect signals
	$disappearTimer.connect("timeout", self, "_on_disappearTimer_timeout")
	
func appear(): #appear when added to area
	show()
	
func _input(event):
	if event.is_action_pressed("space"):
		flip_coin()
		
	if Input.is_action_pressed("attack"):
		if can_attack == true and detected_target:
			print("player attacks")
			detected_target.attacked(dame)

func _physics_process(delta):
	update()
	#moving
	move_and_animation(delta)
	#check if can attack
	_detect_enemy()
	
func move_and_animation(delta):
	var motion = Vector2()

	if playerMovable:
		if Input.is_action_pressed("move_up"):
			motion += Vector2(0, -1)
			$Sprite.animation = "walk"
			$Sprite.flip_h = false
			$playerRayCast.set("cast_to", Vector2(cast_length,0))
			
		elif Input.is_action_pressed("move_bottom"):
			motion += Vector2(0, 1)
			$Sprite.animation = "walk"
			$Sprite.flip_h = true
			$playerRayCast.set("cast_to", Vector2(cast_length * (-1) ,0))
			
		elif Input.is_action_pressed("move_left"):
			motion += Vector2(-1, 0)
			$Sprite.animation = "walk"
			$Sprite.flip_h = true
			$playerRayCast.set("cast_to", Vector2(cast_length * (-1),0))
			
		elif Input.is_action_pressed("move_right"): 
			motion += Vector2(1, 0)
			$Sprite.animation = "walk"
			$Sprite.flip_h = false
			$playerRayCast.set("cast_to", Vector2(cast_length,0))
			
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

func _detect_enemy():
	if $playerRayCast.is_colliding():
		#for enemy in get_tree().get_nodes_in_group("enemies"):
		#	if $playerRayCast.get_collider() == enemy:
				#print("interact with monster")
		#		can_attack = true
		#		detected_target = enemy
		#		emit_signal("interact", true)
				#print(detected_target.get_name())
		var collider_name = $playerRayCast.get_collider().get_name()
		var collider_obj = $playerRayCast.get_collider()
		print(collider_name)
		if "enemy" in str(collider_name):
			#print("interact with monster")
			can_attack = true
			detected_target = collider_obj
			
	else:
		#print("out of interact with monster")
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
	SAnim = "hurt"
	print("player is attacked")
	var damage_received = damage - def
	if damage_received > 0:
		emit_signal("player_attacked", damage_received)
		
func player_dead():
	$disappearTimer.start()
	$playerSprite.animation = "dead"

func _on_disappearTimer_timeout():
	queue_free()
	pass
	
func updateHP(newHP):
	HP = newHP
	
#called when level up
func levelup():
	HP = HP * 3/2
	def = def * 3/2
	dame = dame + 10
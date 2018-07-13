extends KinematicBody2D

const MOTION_SPEED = 550 # Pixels/second
var playerMovable

func _ready():
	set_process_input(true)
	playerMovable = true
	
func _input(event):
	if event.is_action_pressed("space"):
		flip_coin()

func _physics_process(delta):
	var motion = Vector2()

	if(playerMovable):
		if Input.is_action_pressed("move_up"):
			motion += Vector2(0, -1)
		if Input.is_action_pressed("move_bottom"):
			motion += Vector2(0, 1)
		if Input.is_action_pressed("move_left"):
			motion += Vector2(-1, 0)
		if Input.is_action_pressed("move_right"):
			motion += Vector2(1, 0)
	
	motion = motion.normalized() * MOTION_SPEED

	move_and_slide(motion)

# Flips a coin.
func flip_coin():
	get_parent().get_parent().get_node("Sound/CoinFlip").play()
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
	var playerPos = Vector2(self.position.x,self.position.y)
	return playerPos
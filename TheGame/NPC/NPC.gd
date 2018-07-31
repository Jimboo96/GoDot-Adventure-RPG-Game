extends KinematicBody2D
signal start_dialogue
signal end_dialogue

# When player enters NPC's area2d, they can be interacted with.
var NPCInteractionReady = false
# Switched to true, when the interaction begins with the NPC.
var NPCInteractionGoingOn = false
# Memory variable for NPC position to check if it's stuck.
var memoryPosition = null
# Walking direction (north,west,east,south)
var directionToGo = null
# animations for different directions and standing in place.
var animationToPlay = null
# Is true when the NPC is able to turn around when it gets stuck.
var directionChangeable = true

# Walking speed.
const MOTION_SPEED = 30
# When the movement difference is less than this, assign a new direction
# for the NPC.
const REVERSE_MOVEMENT_DIFF = 0.5
# Number of voicefiles and sprites in the game files.
const NUMBER_OF_MALE_VOICELINES = 8
const NUMBER_OF_FEMALE_VOICELINES = 6
const NUMBER_OF_NPC_SPRITES = 4

var gender

# Assign a random gender and sprite accoring to the gender
# when entering scene. Also hides the speech bubbles above NPC's.
func _ready():
	gender = random_gender()
	random_npc_sprite(gender)
	$BubbleSprite.hide()

func _physics_process(delta):
	var motion = Vector2()
	# Shows speech bubble, when NPC can be talked to. 
	if NPCInteractionReady && !NPCInteractionGoingOn && !global.playerIsInteracting:
		$BubbleSprite.show()
	else:
		$BubbleSprite.hide()
	# If the NPC is moving, it will constantly check if it is stuck
	# or not. If it gets stuck, then it's direction will randomly
	# change and it starts moving towards the new direction.
	if !NPCInteractionGoingOn:
		check_position_difference()
		if directionToGo == null: 
			randomize_way()
			
		if directionToGo == "north":
			motion += Vector2(0,-1)
		elif directionToGo == "east":
			motion += Vector2(1,0)
		elif directionToGo == "south":
			motion += Vector2(0,1)
		elif directionToGo == "west":
			motion += Vector2(-1,0)
		else:
			motion = Vector2(0,0)
			
		motion = motion.normalized() * MOTION_SPEED
		move_and_slide(motion)

# Checks if the NPC is stuck.
func check_position_difference():
	if memoryPosition != null && directionChangeable:
		if directionToGo == "north":
			if memoryPosition.y - self.position.y < REVERSE_MOVEMENT_DIFF:
				randomize_way()
		elif directionToGo == "east":
			if abs(memoryPosition.x - self.position.x) < REVERSE_MOVEMENT_DIFF:
				randomize_way()
		elif directionToGo == "south":
			if self.position.y - memoryPosition.y < REVERSE_MOVEMENT_DIFF:
				randomize_way()
		elif directionToGo == "west":
			if abs(self.position.x - memoryPosition.x) < REVERSE_MOVEMENT_DIFF:
				randomize_way()
	memoryPosition = self.position

# Gets a new direction for the npc to walk towards to.
func randomize_way():
	if directionChangeable:
		var randomNum = randi()%4
		if randomNum == 0:
			directionToGo = "north"
			animationToPlay = "up"
		elif randomNum == 1:
			directionToGo = "east"
			animationToPlay = "right"
		elif randomNum == 2:
			directionToGo = "south"
			animationToPlay = "down"
		elif randomNum == 3:
			directionToGo = "west"
			animationToPlay = "left"
		$NPCSprite/AnimationPlayer.play(animationToPlay)
		directionChangeable = false
		$DirectionTimer.start()

# When player presses the interaction key, the NPC stops
# and starts the dialogue.
func _input(event):
	if NPCInteractionReady && !NPCInteractionGoingOn && !global.playerIsInteracting:
		if event.is_action_pressed("interact"):
			global.player.playerMovable = false
			NPCInteractionGoingOn = true
			global.playerIsInteracting = true
			$NPCSprite/AnimationPlayer.play("standing")
			emit_signal("start_dialogue")
			random_voice_line(gender)
	elif NPCInteractionGoingOn && NPCInteractionReady && global.playerIsInteracting:
		if event.is_action_pressed("interact"):
			dialog_proceed()

# When the interaction key is pressed again, the NPC will stand still
# for a moments and then gets a new random direction to walk towards to.
func dialog_proceed():
	$NPCSprite/AnimationPlayer.stop()
	if !$NPCSprite/AnimationPlayer.is_playing():
		global.player.playerMovable = true
		emit_signal("end_dialogue")
		$InteractionEndTimer.start()

func _on_DirectionTimer_timeout():
	directionChangeable = true

func _on_InteractionEndTimer_timeout():
	NPCInteractionGoingOn = false
	global.playerIsInteracting = false
	randomize_way()

# Gets a random voice line to play on the start of the interaction.
func random_voice_line(var gender):
	var randomLine = 0
	if gender == "male": 
		randomLine = randi()%NUMBER_OF_MALE_VOICELINES + 1
	elif gender == "female": 
		randomLine = randi()%NUMBER_OF_FEMALE_VOICELINES + 1

	var fileName = "sfx_" + gender + "voice" + str(randomLine) + ".wav"
	var speechPlayer = $voiceLine
	var audioFile = "res://sound/NPC_voice/" + fileName
	if File.new().file_exists(audioFile):
		var sfx = load(audioFile) 
		speechPlayer.stream = sfx
		speechPlayer.play()

# Gets a random NPC sprite acording to the gender variable.
func random_npc_sprite(var gender):
	var randomNum = randi()%4 + 1
	var fileName = "npc_" + gender + str(randomNum)
	var npcSprite = $NPCSprite
	var spriteFile = "res://assets/characters/" + fileName + "/" + fileName + ".png"
	if File.new().file_exists(spriteFile):
		var sprite = load(spriteFile) 
		npcSprite.texture = sprite

# Assigns a random gender to NPC in scene.
func random_gender():
	var randomNum = randi()%2 + 1
	if randomNum == 1: return "male"
	else: return "female"

func _on_Area2D_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.get_name() == "player":
		NPCInteractionReady = true

func _on_Area2D_body_shape_exited(body_id, body, body_shape, area_shape):
	if body.get_name() == "player":
		NPCInteractionReady = false
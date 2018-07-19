extends KinematicBody2D
signal start_dialogue
signal end_dialogue

var NPCInteractionReady = false
var NPCInteractionGoingOn = false
var memoryPosition = null
var directionToGo = null
var animationToPlay = null
var directionChangeable = true

const MOTION_SPEED = 30
const REVERSE_MOVEMENT_DIFF = 0.5
const NUMBER_OF_MALE_VOICELINES = 21
const NUMBER_OF_FEMALE_VOICELINES = 14
const NUMBER_OF_NPC_SPRITES = 4

var gender

func _ready():
	gender = random_gender()
	random_npc_sprite(gender)

func _physics_process(delta):
	var motion = Vector2()
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

func _on_Area2D_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.get_name() == "player" && !NPCInteractionReady && !NPCInteractionGoingOn:
		NPCInteractionReady = true

func _on_Area2D_body_shape_exited(body_id, body, body_shape, area_shape):
	if body.get_name() == "player":
		NPCInteractionReady = false

func _input(event):
	if NPCInteractionReady && !NPCInteractionGoingOn && !global.playerIsInteracting:
		if event.is_action_pressed("interact"):
			global.playerMovable = false
			NPCInteractionGoingOn = true
			global.playerIsInteracting = true
			$NPCSprite/AnimationPlayer.play("standing")
			emit_signal("start_dialogue")
			random_voice_line(gender)
	elif NPCInteractionGoingOn && NPCInteractionReady && global.playerIsInteracting:
		if event.is_action_pressed("interact"):
			dialog_proceed()

func dialog_proceed():
	$NPCSprite/AnimationPlayer.stop()
	if !$NPCSprite/AnimationPlayer.is_playing():
		global.playerMovable = true
		emit_signal("end_dialogue")
		$InteractionEndTimer.start()

func _on_DirectionTimer_timeout():
	directionChangeable = true

func _on_InteractionEndTimer_timeout():
	NPCInteractionGoingOn = false
	global.playerIsInteracting = false
	randomize_way()
	
func random_voice_line(var gender):
	var randomLine = 0
	if gender == "male": 
		randomLine = randi()%NUMBER_OF_MALE_VOICELINES + 1
	elif gender == "female": 
		randomLine = randi()%NUMBER_OF_FEMALE_VOICELINES + 1

	var fileName = "sfx_" + gender + "voice" + str(randomLine) + ".wav"
	var speechPlayer = $voiceLine
	var audioFile = "res://sfx/NPC_voice/" + fileName
	if File.new().file_exists(audioFile):
		var sfx = load(audioFile) 
		speechPlayer.stream = sfx
		speechPlayer.play()

func random_npc_sprite(var gender):
	var randomNum = randi()%4 + 1
	var fileName = "npc_" + gender + str(randomNum) + ".png"
	var npcSprite = $NPCSprite
	var spriteFile = "res://textures/" + fileName
	if File.new().file_exists(spriteFile):
		var sprite = load(spriteFile) 
		npcSprite.texture = sprite

func random_gender():
	var randomNum = randi()%2 + 1
	if randomNum == 1: return "male"
	else: return "female"
extends KinematicBody2D
signal start_dialogue
signal end_dialogue

# When player enters NPC's area2d, they can be interacted with.
var NPCInteractionReady = false
# Switched to true, when the interaction begins with the NPC.
var NPCInteractionGoingOn = false

# Number of lines in json files in different parts of quests.
const NUMBER_OF_LINES_PRE_QUEST = 9
const NUMBER_OF_LINES_DURING_QUEST = 1
const NUMBER_OF_LINES_QUEST_COMPLETE = 2
const NUMBER_OF_LINES_AFTER_QUEST = 1

const NUMBER_OF_MALE_VOICELINES = 8

# lineIndex is used to tell, which line of dialogue to get
# from the json file.
# numberOfLines is used to loop the conversation for the 
# number of lines of dialogue in each part of the quest.
var lineIndex = 1
var numberOfLines = 0

func _ready():
	$NPCSprite/AnimationPlayer.play("standing")
	# Hide the yellow exclamation mark when the quest is started.
	if global.quest1State != "NOT_STARTED":
		$QuestSprite.hide()

func _physics_process(delta):
	# Shows the yellwo exclamation mark all time when quest is not started.
	if !NPCInteractionGoingOn && global.quest1State == "NOT_STARTED":
		$QuestSprite.show()
	elif NPCInteractionGoingOn:
		$QuestSprite.hide()
	
	# Shows the speech bubble above npc, when they can be talked to.
	if NPCInteractionReady && !NPCInteractionGoingOn:
		$BubbleSprite.show()
	else:
		$BubbleSprite.hide()

# Set the amount of lines and the index of lines here.
func _input(event):
	if NPCInteractionReady && !NPCInteractionGoingOn && !global.player.isInteracting:
		if event.is_action_pressed("interact"):
			random_voice_line()
			if global.quest1State == "NOT_STARTED":
				numberOfLines = NUMBER_OF_LINES_PRE_QUEST
				lineIndex = 1
			elif global.quest1State == "STARTED":
				if global.secretAreaKeyFound:
					numberOfLines = NUMBER_OF_LINES_PRE_QUEST + NUMBER_OF_LINES_DURING_QUEST + NUMBER_OF_LINES_QUEST_COMPLETE
					lineIndex = numberOfLines - 1
				else:
					numberOfLines = NUMBER_OF_LINES_PRE_QUEST + NUMBER_OF_LINES_DURING_QUEST
					lineIndex = numberOfLines
			elif global.quest1State == "COMPLETE":
				numberOfLines = NUMBER_OF_LINES_PRE_QUEST + NUMBER_OF_LINES_DURING_QUEST + NUMBER_OF_LINES_QUEST_COMPLETE + NUMBER_OF_LINES_AFTER_QUEST
				lineIndex = numberOfLines
			quest_dialogue_handler()
	elif NPCInteractionGoingOn && NPCInteractionReady && global.player.isInteracting:
		if event.is_action_pressed("interact"):
			quest_dialogue_handler()

func quest_dialogue_handler():
	global.player.playerMovable = false
	NPCInteractionGoingOn = true
	global.player.isInteracting = true
	if global.quest1State == "NOT_STARTED":
		if lineIndex <= numberOfLines:
			$Dialogue.quest_dialogue(lineIndex)
			lineIndex += 1
		else:
			dialogue_end("STARTED")
	elif global.quest1State == "STARTED":
		# End of the quest ----------------
		if global.secretAreaKeyFound:
			if lineIndex <= numberOfLines:
				$Dialogue.quest_dialogue(lineIndex)
				lineIndex += 1
			else:
				get_quest_reward()
				dialogue_end("COMPLETE")
		# ---------------------------------
		elif lineIndex <= numberOfLines:
			$Dialogue.quest_dialogue(lineIndex)
			lineIndex += 1
		else:
			dialogue_end("STARTED")
	elif global.quest1State == "COMPLETE":
		if lineIndex <= numberOfLines:
			$Dialogue.quest_dialogue(lineIndex)
			lineIndex += 1
		else:
			dialogue_end("COMPLETE")

# Sets the quest state to different states, when player 
# gets forward in the quest. Also resets dialogue and player
# movement and interaction booleans.
func dialogue_end(var state):
	global.quest1State = state
	global.player.playerMovable = true
	$Dialogue.reset_text(null)
	NPCInteractionGoingOn = false
	global.player.isInteracting = false
	lineIndex = 1

# Gets a random voice line to play on the start of the interaction.
func random_voice_line():
	var randomLine = 0
	randomLine = randi()%NUMBER_OF_MALE_VOICELINES + 1
	var fileName = "sfx_malevoice" + str(randomLine) + ".wav"
	var speechPlayer = $voiceLine
	var audioFile = "res://sound/NPC_voice/" + fileName
	if File.new().file_exists(audioFile):
		var sfx = load(audioFile)
		speechPlayer.stream = sfx
		speechPlayer.play()

# Gives the quest reward to player after quest completion.
func get_quest_reward():
	get_tree().get_root().get_node("Main/HUD").quest_complete()
	get_tree().get_root().get_node("Main/HUD").gain_exp(500, null)

func _on_Area2D_body_shape_entered(body_id, body, body_shape, area_shape):
	if body != null:
		if body.get_name() == "player" && !NPCInteractionReady && !NPCInteractionGoingOn:
			NPCInteractionReady = true

func _on_Area2D_body_shape_exited(body_id, body, body_shape, area_shape):
	if body != null:
		if body.get_name() == "player":
			NPCInteractionReady = false
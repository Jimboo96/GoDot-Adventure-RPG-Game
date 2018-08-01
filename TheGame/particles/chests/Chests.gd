extends Node2D

# When player body enters chest area, it can be opened.
var chestOpenable = false
# Chest index in room.
var chestNum = 1
# State to check if the chests have been reseted.
var chestsReseted = false

# Minimum and maximum number of chests per room.
const MIN_CHEST_NUMBER = 1
const MAX_CHEST_NUMBER = 5
var chestSound
var axeSound


func _ready():
	#wow such nice recursive function wow
	var sound = global.find_node_by_name(get_tree().get_root(), "Sound")
	#if(sound): printt(sound, sound.get_name())
	
	#now you can do this
	chestSound = sound.get_node("OpenChest")
	axeSound = sound.get_node("PickUp")


func _process(delta):
	if !chestsReseted: reset_chests()
	chest_icon_handler()


func _input(event):
	if(chestOpenable):
		if event.is_action_pressed("interact"):
			# Set horizontal closed chest sprite to open.
			if get_node("chest" + str(chestNum) + "/TileMap").get_cell(0,0) == 2:
				get_node("chest" + str(chestNum) + "/TileMap").set_cell(0,0,0)
				#print(get_tree().get_root().get_child(1).get_name())
				chestSound.play()
				get_reward(chestNum)
			# Set vertical closed chest sprite to open.
			elif get_node("chest" + str(chestNum) + "/TileMap").get_cell(0,0) == 3:
				get_node("chest" + str(chestNum) + "/TileMap").set_cell(0,0,1)
				chestSound.play()
				get_reward(chestNum)
			# Set tree stump with axe in it to a normal tree stump.
			elif get_node("chest" + str(chestNum) + "/TileMap").get_cell(0,0) == 5:
				get_node("chest" + str(chestNum) + "/TileMap").set_cell(0,0,4)
				#get_parent().get_node("Sound/PickUp").play()
				axeSound.play()
				get_reward(chestNum)
			# Set vertical closed chest sprite to open.
			elif get_node("chest" + str(chestNum) + "/TileMap").get_cell(0,0) == 3:
				get_node("chest" + str(chestNum) + "/TileMap").set_cell(0,0,1)
				chestSound.play()
				get_reward(chestNum)
			# Set tree stump with axe in it to a normal tree stump.
			elif get_node("chest" + str(chestNum) + "/TileMap").get_cell(0,0) == 5:
				get_node("chest" + str(chestNum) + "/TileMap").set_cell(0,0,4)
				chestSound.play()
				get_reward(chestNum)
			save_chest_states()

func reset_chests():
	#If there are chests that have been opened, this sets them to open when entering room.
	for i in range(MIN_CHEST_NUMBER,MAX_CHEST_NUMBER):
		if get_node("chest" + str(i) + "/ChestIcon") != null:
			get_node("chest" + str(i) + "/ChestIcon").hide()
		var globalVarName = global.current_area + "Chest" + str(i)
		if global.get(globalVarName):
			if get_node("chest" + str(i) + "/TileMap").get_cell(0,0) == 2:
				get_node("chest" + str(i) + "/TileMap").set_cell(0,0,0)
			elif get_node("chest" + str(i) + "/TileMap").get_cell(0,0) == 3:
				get_node("chest" + str(i) + "/TileMap").set_cell(0,0,1)
			elif get_node("chest" + str(i) + "/TileMap").get_cell(0,0) == 5:
				get_node("chest" + str(i) + "/TileMap").set_cell(0,0,4)
	chestsReseted = true
	
func get_reward(var chestNum):
	var chestNode = get_node("chest" + str(chestNum) + "/Dialogue")
	if chestNode != null:
		chestNode.start_chest_dialogue(chestNum, global.current_area)
		#items are actually added in dialogue

func save_chest_states():
	# Saves chest states into their corresponding global variables.
	var globalVarName = global.current_area + "Chest" + str(chestNum)
	if globalVarName in global:
		global.set(globalVarName, true)
		
func chest_icon_handler():
	var globalVarName = global.current_area + "Chest" + str(chestNum)
	if !global.get(globalVarName):
		if chestOpenable && get_node("chest" + str(chestNum) + "/ChestIcon") != null: 
			get_node("chest" + str(chestNum) + "/ChestIcon").show()
		elif !chestOpenable && get_node("chest" + str(chestNum) + "/ChestIcon") != null: 
			get_node("chest" + str(chestNum) + "/ChestIcon").hide()
	elif global.get(globalVarName):
		if get_node("chest" + str(chestNum) + "/ChestIcon") != null: 
			get_node("chest" + str(chestNum) + "/ChestIcon").hide()

# Set the chest index by checking which area player body entered.
func _on_chest1_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.get_name() == "player":
		chestOpenable = true
		chestNum = 1

func _on_chest1_body_shape_exited(body_id, body, body_shape, area_shape):
	if body.get_name() == "player":
		chestOpenable = false

func _on_chest2_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.get_name() == "player":
		chestOpenable = true
		chestNum = 2

func _on_chest2_body_shape_exited(body_id, body, body_shape, area_shape):
	if body.get_name() == "player":
		chestOpenable = false
		
func _on_chest3_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.get_name() == "player":
		chestOpenable = true
		chestNum = 3

func _on_chest3_body_shape_exited(body_id, body, body_shape, area_shape):
	if body.get_name() == "player":
		chestOpenable = false
		
func _on_chest4_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.get_name() == "player":
		chestOpenable = true
		chestNum = 4

func _on_chest4_body_shape_exited(body_id, body, body_shape, area_shape):
	if body.get_name() == "player":
		chestOpenable = false
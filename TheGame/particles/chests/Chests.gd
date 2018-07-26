extends Node2D

# When player body enters chest area, it can be opened.
var chestOpenable
# Chest index in room.
var chestNum
# State to check if the chests have been reseted.
var chestsReseted

# Minimum and maximum number of chests per room.
const MIN_CHEST_NUMBER = 1
const MAX_CHEST_NUMBER = 5

func _ready():
	chestsReseted = false
	chestOpenable = false
	chestNum = 0

func _process(delta):
	if !chestsReseted:
		reset_chests()

func _input(event):
	#print(get_tree().current_scene.areaName)
	if(chestOpenable):
		if event.is_action_pressed("interact"):
			# Set horizontal closed chest sprite to open.
			if get_node("chest" + str(chestNum) + "/TileMap").get_cell(0,0) == 2:
				get_node("chest" + str(chestNum) + "/TileMap").set_cell(0,0,0)
				get_tree().get_root().get_child(1).get_node("Sound/OpenChest").play()
				get_reward()
			# Set vertical closed chest sprite to open.
			elif get_node("chest" + str(chestNum) + "/TileMap").get_cell(0,0) == 3:
				get_node("chest" + str(chestNum) + "/TileMap").set_cell(0,0,1)
				get_tree().get_root().get_child(1).get_node("Sound/OpenChest").play()
				get_reward()
			# Set tree stump with axe in it to a normal tree stump.
			elif get_node("chest" + str(chestNum) + "/TileMap").get_cell(0,0) == 5:
				get_node("chest" + str(chestNum) + "/TileMap").set_cell(0,0,4)
				get_tree().get_root().get_child(1).get_node("Sound/PickUp").play()
				get_reward()
			save_chest_states()

func reset_chests():
	#If there are chests that have been opened, this sets them to open when entering room.
	for i in range(MIN_CHEST_NUMBER,MAX_CHEST_NUMBER):
		#var globalVarName = get_tree().current_scene.get_name() + "Chest" + str(i) + "Found"
		var globalVarName = get_tree().current_scene.areaName + "Chest" + str(i) + "Found"
		if global.get(globalVarName):
			if get_node("chest" + str(i) + "/TileMap").get_cell(0,0) == 2:
				get_node("chest" + str(i) + "/TileMap").set_cell(0,0,0)
			elif get_node("chest" + str(i) + "/TileMap").get_cell(0,0) == 3:
				get_node("chest" + str(i) + "/TileMap").set_cell(0,0,1)
			elif get_node("chest" + str(i) + "/TileMap").get_cell(0,0) == 5:
				get_node("chest" + str(i) + "/TileMap").set_cell(0,0,4)
	chestsReseted = true
	
func get_reward():
	# TODO: Reward system, after opening a chest.
	#var currentScene = get_tree().current_scene.get_name()
	var currentScene = get_tree().current_scene.areaName #name of current area
	if(currentScene != null && chestNum != null):
		print("TODO Rewards go into inventory")
		
func save_chest_states():
	# Saves chest states into their corresponding global variables.
	#var globalVarName = get_tree().current_scene.get_name() + "Chest" + str(chestNum) + "Found"
	var globalVarName = get_tree().current_scene.areaName + "Chest" + str(chestNum) + "Found"
	if globalVarName in global:
		global.set(globalVarName, true)

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
extends Node

var current_scene = null
var last_area # previous area
var player
var current_area #area name from main

var damageFromWeapons = 0
var armorFromArmor = 0
var url_PlayerGear = "user://PlayerGear.bin"
onready var playerGear = Global_DataParser.load_data(url_PlayerGear)
var gear = {}
var playerPosSet = false

# area1 variables
var area1Chest1
var area1Chest2
var area1Position = Vector2()
# A secret switch behind the grave to open a secret area in area3.
var area1Switch

# area2 variables
var area2Chest1
var area2Chest2
var area2Chest3
var area2Position = Vector2()

# area3 variables
var area3Chest1
var area3Chest2
var area3Position = Vector2()

# house1 variables
var house1Chest1
var house1Chest2
var house1Chest3
var house1Chest4
var house1Position = Vector2()
# For playing the door close sound after exiting house to area1.
var house1Exited

# secret area variables
var secretAreaChest1
var secretAreaKeyFound
var secretAreaPosition = Vector2()

var root
var playerIsInteracting = false
var playerMovable = true

# States: NOT_STARTED, STARTED, COMPLETED
var quest1State = "NOT_STARTED"

var restartBool = false

func _ready():
	root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )
	gear_data_preloader()
	load_level_on_start()


func goto_scene(path):
	call_deferred("_deferred_goto_scene",path)


func _deferred_goto_scene(path):
	get_parent().get_node("Main").goto_area(path)
	get_parent().get_node("Main/HUD/Transition").fade(path)
	playerPosSet = false
	pass


func goto_main(path):	
	call_deferred("_deferred_main",path)

func back_to_menu():
	var main = find_node_by_name(get_tree().get_root(), "Main")
	if main != null:
		main.queue_free()
	call_deferred("_deferred_menu","res://menu.tscn")
	_ready() #reloads stuff
	restartBool = true

#this function actually changes scene to main and not between childs of the main.tscn
func _deferred_main(path):
	printt("current scene",current_scene)
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	root.add_child(current_scene)
	current_scene = root.get_child(5)
	get_tree().set_current_scene( current_scene )

func _deferred_menu(path):
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	root.add_child(current_scene)

	get_tree().set_current_scene( current_scene )

# math func
func cartesian_to_isometric(cartesian):
	return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y)/2)


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		Global_Player.save_data()
		get_tree().quit() # default behavior


func update_gear_attributes(dmgUpdate,armorUpdate):
	damageFromWeapons = dmgUpdate
	armorFromArmor = armorUpdate
	var player = find_node_by_name(get_tree().get_root(), "player")
	#if(player): printt(player, player.get_name())
	#else: printt(player, "<- if this is null player is not found")
	player._load_stats()


func find_node_by_name(root, name):
	if(root.get_name() == name): return root
	for child in root.get_children():
		if(child.get_name() == name):
			return child
		var found = find_node_by_name(child, name)
		if(found): return found
	return null


func gear_data_preloader():
	var gear = load_gear_data()
	var data
	for slot in range(0,gear.size()-1):
		var item = gear[String(slot)]
		#printt("item", item)
		data = Global_ItemDatabase.get_item(item["id"])
		#printt("data", data)
		if data.has("damage"):
			damageFromWeapons += data["damage"]
		if data.has("defence"):
			armorFromArmor += data["defence"]


func load_gear_data():
	if (playerGear == null):
		var dict = {"gear":{}}
		for slot in range (0, 8):
			var placeholder = slot+1
			dict["gear"][String(slot)] = {"id": str(placeholder), "amount": 0}
		Global_DataParser.write_data(url_PlayerGear, dict)
		gear = dict["gear"]
	else:
		gear = playerGear["gear"]
	return gear


func reward(id):
	if id < 10:
		print("ERROR! Trying to get placeholders as a reward. ERROR! ")
		return
	var item = Global_ItemDatabase.get_item(id)
	Global_Player.inventory_addItem(id)
	name = item["name"]
	printt("You  got a reward! It's: a", name)


#skill and statTree vars
var Str
var Agi
var Const
var player_lvl
var player_max_hp

const SAVE_PATH = "user://statFile.json"
const LOAD_PATH = "user://skillFile.json"
var PATH_TO_FILE 

var skill_enabled
var skill_upgrade
var skill_upgrade_2

func _load_player_stats(PATH):
	var load_file = File.new()
	
	if PATH == 1:
		PATH_TO_FILE = SAVE_PATH
	elif PATH == 2:
		PATH_TO_FILE = LOAD_PATH
	
	if not load_file.file_exists(PATH_TO_FILE):
		print("File does not exist")
		return
	
	var err = load_file.open_encrypted_with_pass(PATH_TO_FILE, load_file.READ, "mypass")
	var current_line = {}
	current_line = parse_json(load_file.get_line())
	return current_line
	load_file.close()

func load_level_on_start():
	var load_file = File.new()
	
	if not load_file.file_exists(SAVE_PATH):
		print("File does not exist")
		player_lvl = 1
		return
	else:
		var err = load_file.open_encrypted_with_pass(SAVE_PATH, load_file.READ, "mypass")
		var current_line = {}
		current_line = parse_json(load_file.get_line())
		player_lvl = current_line["Lvl"]
		print("global level loaded")
	load_file.close()


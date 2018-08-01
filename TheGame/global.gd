extends Node

var current_scene = null
var last_area # previous area
var player
var current_area #area name from main
var playerPosSet = false

# area1 variables
var area1Chest1
var area1Position = Vector2()
# A secret switch behind the grave to open a secret area in area3.
var area1Switch

# area2 variables
var area2Chest1
var area2Chest2
var area2Chest3
var area2Position = Vector2()
var area2Enemies = 3

# area3 variables
var area3Chest1
var area3Chest2
var area3Position = Vector2()
var area3Enemies = 3

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

var playerIsInteracting = false
var playerMovable = true

# States: NOT_STARTED, STARTED, COMPLETED
var quest1State = "NOT_STARTED"

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )
	load_level_on_start()

func goto_scene(path):
	get_parent().get_child(1).get_node("HUD/Transition").fade(path)
	playerPosSet = false
	
# math func
func cartesian_to_isometric(cartesian):
	return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y)/2)
	


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


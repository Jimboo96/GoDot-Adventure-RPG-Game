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

var root
var playerIsInteracting = false
var playerMovable = true

# States: NOT_STARTED, STARTED, COMPLETED
var quest1State = "NOT_STARTED"


func _ready():
	root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )
	gear_data_preloader()


func goto_scene(path):
	call_deferred("_deferred_goto_scene",path)


func _deferred_goto_scene(path):
	get_parent().get_child(4).goto_area(path)
	get_parent().get_child(4).get_node("HUD/Transition").fade(path)
	playerPosSet = false
	pass


func goto_main(path):
	call_deferred("_deferred_main",path)


#this function actually changes scene to main and not between childs of the main.tscn
func _deferred_main(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	root.add_child(current_scene)
	current_scene = root.get_child(4)
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
	printt("damage from weapons",damageFromWeapons)
	printt("armor from armor",armorFromArmor)


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
	
	
extends Node

var current_scene = null
var last_area # previous area
var player
var current_area #area name from main
var damageFromWeapons = 0
var armorFromArmor = 0
var gear = {}

# area1 variables
var area1Chest1Found
var area1Position = Vector2()
# A secret switch behind the grave to open a secret area in area3.
var area1Switch

# area2 variables
var area2Chest1Found
var area2Chest2Found
var area2Chest3Found
var area2Position = Vector2()
var area2Enemies = 3

# area3 variables
var area3Chest1Found
var area3Chest2Found
var area3Position = Vector2()
var area3Enemies = 3

# house1 variables
var house1Chest1Found
var house1Chest2Found
var house1Chest3Found
var house1Chest4Found
var house1Position = Vector2()
# For playing the door close sound after exiting house to area1.
var house1Exited

# secret area variables
var secretAreaChest1Found
var secretAreaKeyFound
var secretAreaPosition = Vector2()

var root

func _ready():
	root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )
	#print("get_children @_ready() ",root.get_children())
	
	ghetto_gear_data_preloader()

func goto_scene(path):
	call_deferred("_deferred_goto_scene",path)


func _deferred_goto_scene(path):
	get_parent().get_child(4).goto_area(path)
	pass


func goto_main():
	call_deferred("_deferred_main")


#this function actually changes scene to main and not between childs of the main.tscn
func _deferred_main():
	#print("path: ", path)
	current_scene.free()
	var s = ResourceLoader.load("res://main.tscn")
	current_scene = s.instance()
	#print("root children: ",root.get_children())
	#print("current scene: ",current_scene.get_name())
	root.add_child(current_scene)
	current_scene = root.get_child(4)
	get_tree().set_current_scene( current_scene )
	#print("get_children @end of _deferred_main() ) ",root.get_children())
	

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

func ghetto_gear_data_preloader():
	gear = Global_DataParser.load_data("user://PlayerGear.bin")
	printt(gear,"#######" ,gear.values() )
	
	#for slot in range (1, 8):
	#	print(gear[String(slot)]["id"])



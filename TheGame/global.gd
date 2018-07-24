extends Node

var current_scene = null
var last_area # previous area
var player
var current_area #area name from main

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

func _ready():
    var root = get_tree().get_root()
    current_scene = root.get_child( root.get_child_count() -1 )

func goto_scene(path):
	get_parent().get_child(1).goto_area(path)
	pass
	
# math func
func cartesian_to_isometric(cartesian):
	return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y)/2)
	

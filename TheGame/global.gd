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

func goto_scene(path):
	get_parent().get_node("Main/HUD/Transition").fade(path)
	playerPosSet = false
	
# math func
func cartesian_to_isometric(cartesian):
	return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y)/2)
	

extends Node

var current_scene = null
var playerMovable = true

# area1 variables
var area1Chest1Found
var area1Position = null
# A secret switch behind the grave to open a secret area in area3.
var area1Switch

# area2 variables
var area2Chest1Found
var area2Chest2Found
var area2Chest3Found
var area2Position = null

# area3 variables
var area3Chest1Found
var area3Chest2Found
var area3Position = null

# house1 variables
var house1Chest1Found
var house1Chest2Found
var house1Chest3Found
var house1Chest4Found
var house1Position = null
# For playing the door close sound after exiting house to area1.
var house1Exited

# secret area variables
var secretAreaChest1Found
var secretAreaKeyFound
var secretAreaPosition = null

# NPC interaction
var playerIsInteracting = false

func _ready():
    var root = get_tree().get_root()
    current_scene = root.get_child( root.get_child_count() -1 )

func goto_scene(path):
    call_deferred("_deferred_goto_scene",path)

func _deferred_goto_scene(path):
    current_scene.free()
    var s = ResourceLoader.load(path)
    current_scene = s.instance()
    get_tree().get_root().add_child(current_scene)
    get_tree().set_current_scene( current_scene )
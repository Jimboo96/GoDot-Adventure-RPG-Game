extends Node

var playerPos

onready var global = get_node("/root/global")
onready var player = global.player
var current_area
# onready var player = get_parent().get_node("walls/player")

#First passageway in a room. Saves player position into a global variable.

func _on_MoveTimer_timeout():
	if(global.current_area == "area1"):
		north_exit()
		global.area1Position = playerPos
		global.goto_scene("res://areas/area2.tscn")
	elif(global.current_area == "area2"):
		south_exit()
		global.area2Position = playerPos
		global.goto_scene("res://areas/area1.tscn")
	elif(global.current_area == "area3"):
		east_exit()
		global.area3Position = playerPos
		global.goto_scene("res://areas/area2.tscn")
	elif(global.current_area == "secretArea"):
		east_exit()
		global.secretAreaPosition = playerPos
		global.goto_scene("res://areas/area3.tscn")

#Second passageway in room. Saves player position into a global variable.
func _on_MoveTimer2_timeout():
	if(global.current_area == "area2"): #get_tree().get_current_scene().get_name()
		west_exit()
		global.area2Position = playerPos
		global.goto_scene("res://areas/area3.tscn")
	elif(global.current_area == "area3"):
		west_exit()
		global.area3Position = playerPos
		global.goto_scene("res://areas/secretArea.tscn")

# Door passageways. Saves player position to global variables.
func _on_DoorTimer_timeout():
	if(global.current_area == "house1"):
		east_exit()
		global.house1Position = playerPos
		global.house1Exited = true
		global.goto_scene("res://areas/area1.tscn")
	elif(global.current_area == "area1"):
		west_exit()
		global.area1Position = playerPos
		global.goto_scene("res://areas/house1.tscn")

# Offset player by few pixels, so they dont spawn on the transistion area when changing scenes.
func north_exit():
	playerPos = player.get_player_pos()
	#print(get_parent().get_node("Area/area").get_name())
	playerPos += Vector2(-40,40)

func south_exit():
	#print(get_parent().get_node("Area/area").get_name())
	playerPos = player.get_player_pos()
	playerPos += Vector2(40,-40)

func west_exit():
	#print(get_parent().get_node("Area/area").get_name())
	playerPos = player.get_player_pos()
	playerPos += Vector2(40,40)

func east_exit():
	#print(get_parent().get_node("Area/area").get_name())
	playerPos = player.get_player_pos()
	playerPos += Vector2(-40,-40)
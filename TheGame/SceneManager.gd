extends Node

var playerPos

onready var global = get_node("/root/global")
var player
var current_area

#First passageway in a room. Saves player position into a global variable.
func _on_MoveTimer_timeout():
	player = global.player
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
	player = global.player
	if(global.current_area == "area2"): 
		west_exit()
		global.area2Position = playerPos
		global.goto_scene("res://areas/area3.tscn")
	elif(global.current_area == "area3"):
		west_exit()
		global.area3Position = playerPos
		global.goto_scene("res://areas/secretArea.tscn")

# Door passageways. Saves player position to global variables.
func _on_DoorTimer_timeout():
	player = global.player
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
	playerPos += Vector2(-40,40)

func south_exit():
	playerPos = player.get_player_pos()
	playerPos += Vector2(40,-40)

func west_exit():
	playerPos = player.get_player_pos()
	playerPos += Vector2(40,40)

func east_exit():
	playerPos = player.get_player_pos()
	playerPos += Vector2(-40,-40)
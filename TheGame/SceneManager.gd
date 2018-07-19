extends Node

var playerPos

#First passageway in a room. Saves player position into a global variable.
func _on_MoveTimer_timeout():
	if(get_tree().get_current_scene().get_name() == "area1"):
		north_exit()
		global.area1Position = playerPos
		get_node("/root/global").goto_scene("res://areas/area2.tscn")
	elif(get_tree().get_current_scene().get_name() == "area2"):
		south_exit()
		global.area2Position = playerPos
		get_node("/root/global").goto_scene("res://areas/area1.tscn")
	elif(get_tree().get_current_scene().get_name() == "area3"):
		east_exit()
		global.area3Position = playerPos
		get_node("/root/global").goto_scene("res://areas/area2.tscn")
	elif(get_tree().get_current_scene().get_name() == "secretArea"):
		east_exit()
		global.secretAreaPosition = playerPos
		get_node("/root/global").goto_scene("res://areas/area3.tscn")

#Second passageway in room. Saves player position into a global variable.
func _on_MoveTimer2_timeout():
	if(get_tree().get_current_scene().get_name() == "area2"):
		west_exit()
		global.area2Position = playerPos
		get_node("/root/global").goto_scene("res://areas/area3.tscn")
	elif(get_tree().get_current_scene().get_name() == "area3"):
		west_exit()
		global.area3Position = playerPos
		get_node("/root/global").goto_scene("res://areas/secretArea.tscn")

# Door passageways. Saves player position to global variables.
func _on_DoorTimer_timeout():
	if(get_tree().get_current_scene().get_name() == "house1"):
		east_exit()
		global.house1Position = playerPos
		global.house1Exited = true
		get_node("/root/global").goto_scene("res://areas/area1.tscn")
	elif(get_tree().get_current_scene().get_name() == "area1"):
		west_exit()
		global.area1Position = playerPos
		get_node("/root/global").goto_scene("res://areas/house1.tscn")

# Offset player by few pixels, so they dont spawn on the transistion area when changing scenes.
func north_exit():
	playerPos = get_parent().get_node("walls/player").get_player_pos()
	playerPos += Vector2(-40,40)

func south_exit():
	playerPos = get_parent().get_node("walls/player").get_player_pos()
	playerPos += Vector2(40,-40)

func west_exit():
	playerPos = get_parent().get_node("walls/player").get_player_pos()
	playerPos += Vector2(10,40)

func east_exit():
	playerPos = get_parent().get_node("walls/player").get_player_pos()
	playerPos += Vector2(10,-40)
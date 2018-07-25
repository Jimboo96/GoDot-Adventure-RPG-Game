extends Node2D
signal halt_player

var doorOpenable
var playerPosReseted
var player

func _ready():
	doorOpenable = false
	playerPosReseted = false

func _process(delta):
	if !playerPosReseted:
		reset_player_pos(global.current_area) #Main.areaName
		pass

func _input(event):
	if(doorOpenable):
		if event.is_action_pressed("interact"):
			doorOpenable = false
			get_tree().get_root().get_child(2).get_node("Sound/OpenDoor").play()
			emit_signal("halt_player")
			get_node("DoorArea/DoorTimer").start()

# Normal movement between areas. Move automatically to next scene after a brief delay.
func _on_MoveArea_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.get_name() == "player":
		emit_signal("halt_player")
		get_node("MoveArea/MoveTimer").start()
		get_tree().get_root().get_child(2).get_node("Sound/WalkingOnLeaves").play(6)

func _on_MoveArea2_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.get_name() == "player":
		emit_signal("halt_player")
		get_node("MoveArea2/MoveTimer2").start()
		get_tree().get_root().get_child(2).get_node("Sound/WalkingOnLeaves").play(6)
		
# Resets players position according to the coordinates that are saved in global variables.
#set init pos if null
func reset_player_pos(var current_scene):
	if current_scene == "area1":
		# For playing the door close sound after exiting house to area1.
		if global.house1Exited:
			get_tree().get_root().get_child(2).get_node("Sound/CloseDoor").play() #
			global.house1Exited = false
		if global.area1Position == Vector2():
			if global.last_area == "area2":
				global.area1Position = Vector2(700, -120)
			else:
				global.area1Position = Vector2(210, 380)
		global.player.position = global.area1Position
		
	elif current_scene == "area2":
		if global.area2Position == Vector2():
			if global.last_area:
				if global.last_area == "area1":
					global.area2Position = Vector2(-480, 410)
				if global.last_area == "area3":
					global.area2Position = Vector2(-333, -500)
				else:
					global.area2Position = Vector2(-480, 410)
		global.player.position = global.area2Position
		
	elif current_scene == "area3":
		if global.area3Position == Vector2():
			if global.last_area == "area2":
				global.area3Position = Vector2(790, 37)
			if global.last_area == "secretArea":
				global.area3Position = Vector2(-775, -780)
			else:
				global.area3Position = Vector2(790, 37)
		global.player.position = global.area3Position
		#Remove the tree blocking the secret way.
		if global.area1Switch:
			get_tree().get_root().get_child(2).get_node("Area/area/walls").set_cell(-19,-5,4)
			
	elif current_scene == "secretArea":
		if global.secretAreaPosition == Vector2():
			global.secretAreaPosition = Vector2(480, 400)
		global.player.position = global.secretAreaPosition
		
	elif current_scene == "house1":
		get_tree().get_root().get_child(2).get_node("Sound/CloseDoor").play()
		if global.house1Position == Vector2():
			global.house1Position = Vector2(864, 135)
		global.player.position = global.house1Position
			
	playerPosReseted = true
	global.playerPosSet = true

func _on_DoorArea_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.get_name() == "player":
		print("door can be opened")
		doorOpenable = true

func _on_DoorArea_body_shape_exited(body_id, body, body_shape, area_shape):
	if body.get_name() == "player":
		doorOpenable = false

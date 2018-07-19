extends Node2D

var doorOpenable
var playerPosReseted

func _ready():
	doorOpenable = false
	playerPosReseted = false
	global.playerMovable = true

func _process(delta):
	if !playerPosReseted:
		reset_player_pos(get_tree().current_scene.get_name())

func _input(event):
	if(doorOpenable):
		if event.is_action_pressed("interact"):
			doorOpenable = false
			get_parent().get_node("Sound/OpenDoor").play()
			global.playerMovable = false
			get_node("DoorArea/DoorTimer").start()

# Normal movement between areas. Move automatically to next scene after a brief delay.
func _on_MoveArea_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.get_name() == "player":
		global.playerMovable = false
		get_node("MoveArea/MoveTimer").start()

func _on_MoveArea2_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.get_name() == "player":
		global.playerMovable = false
		get_node("MoveArea2/MoveTimer2").start()

# Resets players position according to the coordinates that are saved in global variables.
func reset_player_pos(var current_scene):
	if current_scene == "area1":
		# For playing the door close sound after exiting house to area1.
		if global.house1Exited:
			get_parent().get_node("Sound/CloseDoor").play()
			global.house1Exited = false
		if global.area1Position != null:
			get_parent().get_node("walls/player").position = global.area1Position
	elif current_scene == "area2":
		if global.area2Position != null:
			get_parent().get_node("walls/player").position = global.area2Position
	elif current_scene == "area3":
		if global.area3Position != null:
			get_parent().get_node("walls/player").position = global.area3Position
		#Remove the tree blocking the secret way.
		if global.area1Switch:
			get_parent().get_node("walls").set_cell(-19,-5,4)
	elif current_scene == "secretArea":
		if global.secretAreaPosition != null:
			get_parent().get_node("walls/player").position = global.secretAreaPosition
	elif current_scene == "house1":
		get_parent().get_node("Sound/CloseDoor").play()
		if global.house1Position != null:
			get_parent().get_node("walls/player").position = global.house1Position
	playerPosReseted = true

func _on_DoorArea_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.get_name() == "player":
		doorOpenable = true

func _on_DoorArea_body_shape_exited(body_id, body, body_shape, area_shape):
	if body.get_name() == "player":
		doorOpenable = false
extends Area2D

var switchState
var walls

func _ready():
	walls = get_tree().get_root().get_child(1).get_node("Area/area/walls")
	switchState = false

func _input(event):
	#If player is standing on the switchArea, it can be interacted with.
	if(switchState):
		if event.is_action_pressed("interact"):
			# Area1 switches
			if(get_tree().get_root().get_child(1).area_name == "area1"):
				# Set switchState to false so action can only be done once per entering area.
				switchState = false
				if self.get_name() == "SwitchArea1":
					# Secret switch behind the grave.
					if !global.area1Switch:
						get_tree().get_root().get_child(1).get_node("Sound/MoveBlock").play()
						global.area1Switch = true
						print("You hear something large moving somewhere in the forest....")
			# House1 switches
			elif(get_tree().get_root().get_child(1).area_name == "house1"):
				# Door 1. Opens and closes it.
				if self.get_name() == "SwitchArea1":
					if walls.get_cell(6,-11) == 22:
						get_tree().get_root().get_child(1).get_node("Sound/OpenDoor").play()
						walls.set_cell(6,-11,37)
					elif walls.get_cell(6,-11) == 37:
						get_tree().get_root().get_child(1).get_node("Sound/CloseDoor").play()
						walls.set_cell(6,-11,22)
					# Door 2. Opens and closes it.´if the secret key has been found.
				elif self.get_name() == "SwitchArea2":
					if global.secretAreaKeyFound:
						if walls.get_cell(10,-15) == 26:
							get_tree().get_root().get_child(1).get_node("Sound/OpenDoor").play()
							walls.set_cell(10,-15,38)
						elif walls.get_cell(10,-15) == 38:
							get_tree().get_root().get_child(1).get_node("Sound/CloseDoor").play()
							walls.set_cell(10,-15,26)
					else:
						get_tree().get_root().get_child(1).get_node("Sound/LockedDoor").play()
			# Secret area switches.
			elif(get_tree().get_root().get_child(1).area_name == "secretArea"):
				# Set switchState to false so action can only be done once per entering area.
				switchState = false
				if self.get_name() == "SwitchArea1":
					# Secret switch behind the grave.
					if !global.secretAreaKeyFound:
						get_tree().get_root().get_child(1).get_node("Sound/PickUp").play()
						global.secretAreaKeyFound = true
						print("You find a key buried under the flower!")
					
func _on_SwitchArea_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.get_name() == "player":
		switchState = true

func _on_SwitchArea_body_shape_exited(body_id, body, body_shape, area_shape):
	if body.get_name() == "player":
		switchState = false

extends Area2D

var switchState
var walls

func _ready():
	walls = get_parent().get_parent().get_node("walls")
	switchState = false

func _input(event):
	#If player is standing on the switchArea, it can be interacted with.
	if(switchState):
		if event.is_action_pressed("interact"):
			# Area1 switches
			if(get_tree().get_current_scene().get_name() == "area1"):
				# Set switchState to false so action can only be done once per entering area.
				switchState = false
				if self.get_name() == "SwitchArea1":
					# Secret switch behind the grave.
					if !global.area1Switch:
						get_parent().get_parent().get_node("Sound/MoveBlock").play()
						global.area1Switch = true
						print("You hear something large moving somewhere in the forest....")
			# House1 switches
			elif(get_tree().get_current_scene().get_name() == "house1"):
				# Door 1. Opens and closes it.
				if self.get_name() == "SwitchArea1":
					if get_parent().get_parent().get_node("walls").get_cell(6,-11) == 22:
						get_parent().get_parent().get_node("Sound/OpenDoor").play()
						get_parent().get_parent().get_node("walls").set_cell(6,-11,37)
					elif get_parent().get_parent().get_node("walls").get_cell(6,-11) == 37:
						get_parent().get_parent().get_node("Sound/CloseDoor").play()
						get_parent().get_parent().get_node("walls").set_cell(6,-11,22)
					# Door 2. Opens and closes it.´if the secret key has been found.
				elif self.get_name() == "SwitchArea2":
					if global.secretAreaKeyFound:
						if get_parent().get_parent().get_node("walls").get_cell(10,-15) == 26:
							get_parent().get_parent().get_node("Sound/OpenDoor").play()
							get_parent().get_parent().get_node("walls").set_cell(10,-15,38)
						elif get_parent().get_parent().get_node("walls").get_cell(10,-15) == 38:
							get_parent().get_parent().get_node("Sound/CloseDoor").play()
							get_parent().get_parent().get_node("walls").set_cell(10,-15,26)
					else:
						get_parent().get_parent().get_node("Sound/LockedDoor").play()
			# Secret area switches.
			elif(get_tree().get_current_scene().get_name() == "secretArea"):
				# Set switchState to false so action can only be done once per entering area.
				switchState = false
				if self.get_name() == "SwitchArea1":
					# Secret switch behind the grave.
					if !global.secretAreaKeyFound:
						get_parent().get_parent().get_node("Sound/PickUp").play()
						global.secretAreaKeyFound = true
						print("You find a key buried under the flower!")
					
func _on_SwitchArea_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.get_name() == "player":
		switchState = true

func _on_SwitchArea_body_shape_exited(body_id, body, body_shape, area_shape):
	if body.get_name() == "player":
		switchState = false
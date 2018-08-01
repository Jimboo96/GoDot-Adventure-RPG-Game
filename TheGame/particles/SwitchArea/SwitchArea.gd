extends Area2D
signal start_dialogue

var switchState = false
var walls

var doorLockedSprite
var doorOpenableSprite
var objectOfInterestSprite

func _ready():
	walls = get_tree().get_root().get_child(2).get_node("Area/area/walls")
	load_sprites()
	$IconSprite.hide()
	
func _process(delta):
	examine_icon_handler()

func _input(event):
	#If player is standing on the switchArea, it can be interacted with.
	if(switchState && !global.player.isInteracting):
		if event.is_action_pressed("interact"):
			# Area1 switches
			if global.current_area == "area1":
				# Set switchState to false so action can only be done once per entering area.
				switchState = false
				if self.get_name() == "SwitchArea":
					# Secret switch behind the grave.
					if !global.area1Switch:
						get_tree().get_root().get_node("Main/Sound/MoveBlock").play()
						global.area1Switch = true
						get_tree().get_root().get_node("Main/HUD").gain_exp(60, null)
						emit_signal("start_dialogue")
			# House1 switches
			elif(global.current_area == "house1"):
				# Door 1. Opens and closes it.
				if self.get_name() == "SwitchArea1":
					if walls.get_cell(6,-11) == 22:
						get_tree().get_root().get_node("Main/Sound/OpenDoor").play()
						walls.set_cell(6,-11,37)
					elif walls.get_cell(6,-11) == 37:
						get_tree().get_root().get_node("Main/Sound/CloseDoor").play()
						walls.set_cell(6,-11,22)
					# Door 2. Opens and closes it, if the secret key has been found.
				elif self.get_name() == "SwitchArea2":
					if global.secretAreaKeyFound:
						if walls.get_cell(10,-15) == 26:
							get_tree().get_root().get_node("Main/Sound/OpenDoor").play()
							walls.set_cell(10,-15,38)
						elif walls.get_cell(10,-15) == 38:
							get_tree().get_root().get_node("Main/Sound/CloseDoor").play()
							walls.set_cell(10,-15,26)
					else:
						get_tree().get_root().get_node("Main/Sound/LockedDoor").play()
						$IconSprite.texture = doorLockedSprite

			# Secret area switches.
			elif(global.current_area == "secretArea"):
				# Set switchState to false so action can only be done once per entering area.
				switchState = false
				if self.get_name() == "SwitchArea":
					# Key buried under the flower.
					if !global.secretAreaKeyFound:
						get_tree().get_root().get_node("Main/Sound/PickUp").play()						
						get_tree().get_root().get_node("Main/HUD").gain_exp(60, null)
						global.secretAreaKeyFound = true
						emit_signal("start_dialogue")
			elif(global.current_area == "area2"):
				# Read the signpost in area2.
				switchState = false
				if self.get_name() == "SwitchArea" || "SwitchArea2":
					emit_signal("start_dialogue")
			elif(global.current_area == "area3"):
				# Read the signpost in area3.
				switchState = false
				if self.get_name() == "SwitchArea":
					emit_signal("start_dialogue")

# Used to show and hide door icons above the openable doors in house.
func examine_icon_handler():
	if global.current_area == "house1":
		if switchState:
			$IconSprite.show()
		else:
			$IconSprite.hide()
	elif global.current_area == "area1":
		if self.get_name() == "SwitchArea2":
			if switchState:
				$IconSprite.texture = doorOpenableSprite
				$IconSprite.show()
			else:
				$IconSprite.hide()
	elif global.current_area == "area2":
		if self.get_name() == "SwitchArea": $IconSprite.position.y = -120
		elif self.get_name() == "SwitchArea2": $IconSprite.position.y = -80
		if switchState:
			$IconSprite.texture = objectOfInterestSprite
			$IconSprite.show()
		else:
			$IconSprite.hide()
	elif global.current_area == "area3":
		if self.get_name() == "SwitchArea":
			if switchState:
				$IconSprite.position.y = -120
				$IconSprite.texture = objectOfInterestSprite
				$IconSprite.show()
			else:
				$IconSprite.hide()

# Load sprites for icons, so that the texture can be chaned when needed.
func load_sprites():
	var doorLockedSpritePath = "res://assets/icons/doorLockedSprite.png"
	if File.new().file_exists(doorLockedSpritePath):
		doorLockedSprite = load(doorLockedSpritePath)
	
	var doorOpenableSpritePath = "res://assets/icons/doorOpenableSprite.png"
	if File.new().file_exists(doorOpenableSpritePath):
		doorOpenableSprite = load(doorOpenableSpritePath) 
	
	var objectOfInterestSpritePath = "res://assets/icons/objectOfInterestSprite.png"
	if File.new().file_exists(objectOfInterestSpritePath):
		objectOfInterestSprite = load(objectOfInterestSpritePath) 

func _on_SwitchArea_body_shape_entered(body_id, body, body_shape, area_shape):
	if body != null:
		if body.get_name() == "player":
			switchState = true

func _on_SwitchArea_body_shape_exited(body_id, body, body_shape, area_shape):
	if body != null:
		if body.get_name() == "player":
			switchState = false
			$IconSprite.texture = doorOpenableSprite
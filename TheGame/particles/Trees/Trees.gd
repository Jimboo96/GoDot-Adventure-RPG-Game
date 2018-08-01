extends Node2D
signal start_woodcutting

# When player body enters tree area, it can be cut down.
var treeCuttable = false
var treeIsCut = false
var typeOfTree = ""

# Cutdown speed scales with players WC level.
var playerWoodCuttingLevel = 20
const CUT_DOWN_SCALER = 0.1

func _ready():
	# Get player woodcutting level from skills and set the cutdown timer
	# according to the level.
	$TreeIcon.hide()
	playerWoodCuttingLevel = playerWoodCuttingLevel
	set_cutdown_time(playerWoodCuttingLevel)
	
func _process(delta):
	tree_icon_handler()

func _input(event):
	if treeCuttable && !treeIsCut && global.player.ownsAxe:
		if event.is_action_pressed("interact"):
			# Set tree to tree trump.
			if $TileMap.get_cell(0,0) == 0 || $TileMap.get_cell(0,0) == 3:
				$CutDownTimer.start()
				get_tree().get_root().get_node("Main/Sound/ChopWood").play()
				global.player.animationToPlay = "attack" + global.player.directionFacing
				global.player.play_animation(global.player.animationToPlay)
				global.player.playerMovable = false
				global.player.isCuttingWood = true
				treeIsCut = true

#Hide tree icons and show them when entering the tree's area.
func tree_icon_handler():
	if !treeIsCut && treeCuttable:
		$TreeIcon.show()
	else:
		$TreeIcon.hide()

# After cutting down the tree, make it a stump and start growing it back.
func _on_CutDownTimer_timeout():
	get_tree().get_root().get_node("Main/Sound/FallenTree").play()
	if(typeOfTree == "Oak"):
		$TileMap.set_cell(0,0,2)
		$GrowTimer.start()
	elif(typeOfTree == "Spruce"):
		$TileMap.set_cell(0,0,4)
	get_experience()
	global.player.animationToPlay = "standing" + global.player.directionFacing
	global.player.play_animation(global.player.animationToPlay)
	global.player.playerMovable = true
	global.player.isCuttingWood = false

# Grow back the tree that was cut down.
func _on_GrowTimer_timeout():
	if $TileMap.get_cell(0,0) == 2 && typeOfTree == "Oak":
		$TileMap.set_cell(0,0,0)
	elif $TileMap.get_cell(0,0) == 2 && typeOfTree == "Spruce":
		$TileMap.set_cell(0,0,3)
	treeIsCut = false

# Set the time it takes to cut down a tree.
func set_cutdown_time(var WCLevel):
	$CutDownTimer.wait_time = $CutDownTimer.wait_time - (WCLevel * CUT_DOWN_SCALER)
	if $CutDownTimer.wait_time < 1:
		$CutDownTimer.wait_time = 1

#Get some experience after cutting down a tree.
func get_experience():
	get_tree().get_root().get_node("Main/HUD").gain_exp(50, null)

func _on_Tree1_body_shape_entered(body_id, body, body_shape, area_shape):
	if body != null:
		if body.get_name() == "player":
			treeCuttable = true
			typeOfTree = "Oak"

func _on_Tree1_body_shape_exited(body_id, body, body_shape, area_shape):
	if body != null:
		if body.get_name() == "player":
			treeCuttable = false

func _on_Tree2_body_shape_entered(body_id, body, body_shape, area_shape):
	if body != null:
		if body.get_name() == "player":
			treeCuttable = true
			typeOfTree = "Spruce"

func _on_Tree2_body_shape_exited(body_id, body, body_shape, area_shape):
	if body != null:
		if body.get_name() == "player":
			treeCuttable = false
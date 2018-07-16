extends Node

var current_area
var area_name #name from node when added to tree
var player
var walls

var added_first_area = false #if first scene loaded (when start game)

var s = preload("res://areas/area1.tscn")

func _enter_tree(): #first enter
	add_new_scene(s)
	
func _ready():
	add_player_to_current_scene()
	added_first_area = true	
	
func conn_signals():
	if $Area/area/MoveAreas.is_inside_tree():
		#print("true")
		var MoveAreas = get_node("Area/area/MoveAreas")
		var numberOfMoveAreas = MoveAreas.get_child_count()
		var childOfMoveAreas = MoveAreas.get_children()
		for i in numberOfMoveAreas:
			var moveAreaName = childOfMoveAreas[i].get_name()
			var moveAreaTimer = childOfMoveAreas[i].get_child(1) # return timer
			var timerName = moveAreaTimer.get_name()
			var timerPath = get_node("Area/area/MoveAreas/" + moveAreaName + "/" + timerName) # path to timer
			#print(timerPath)
			if timerPath.is_connected("timeout", $SceneManager, "_on_" + timerName + "_timeout"):
				#print("connected %s timer" % timerName)
				timerPath.disconnect("timeout", $SceneManager, "_on_" + timerName + "_timeout") #call when changing scene
			else:
				timerPath.connect("timeout", $SceneManager, "_on_" + timerName + "_timeout")
				#print("connect %s timer" % timerName)
			#print("_on_" + timerName + "_timeout")
			
		#add signal connection from MoveArea.gd, SwitchAreas.gd to player and remove when change scene.
		if MoveAreas.is_connected("halt_player", player, "_on_MoveAreas_halt_player"):
			MoveAreas.disconnect("halt_player", player, "_on_MoveAreas_halt_player")
		else:
			MoveAreas.connect("halt_player", player, "_on_MoveAreas_halt_player")
		
func goto_area(path):
	conn_signals() #disconnect signals from old area
	remove_player_from_current_scene()
	call_deferred("deferred_goto_scene", path)
	
func deferred_goto_scene(path):
	print(" goto scene %s: " %global.current_scene)
	global.last_area = global.current_area
	print(global.last_area)
	#load scene
	s = ResourceLoader.load(path)
	#remove old area
	$Area.remove_child(current_area)
	add_new_scene(s)
	pass
	
func add_new_scene(s):
	print("main add new scene")	
	#load area
	current_area = s.instance()
	#set new var for new area
	area_name = current_area.get_name()  #new name for easy to call during the area is playing
	global.current_scene = current_area
	print(current_area)
	print(global.current_scene)
	current_area.set_name("area")
	#add new area
	
	if $Area.get_child_count() == 0:
		$Area.add_child(current_area)
	#set global area (name)
	global.current_area = area_name
	#print("added new scenes")
	#add player to this scene
	if added_first_area == true:
		add_player_to_current_scene()
	pass
	
func add_player_to_current_scene():
	player = $player
	walls = $Area/area/walls
	self.remove_child(player)
	walls.add_child(player)
	#walls.set_owner(player)
	player.appear()
	player = get_tree().get_root().get_child(1).get_node("Area/area/walls/player")
	#save to global
	global.player = player
	#connect timer and move areas' signals
	call_deferred("conn_signals") #consider of calling deferred
	#reset player stage that player can move
	player.playerMovable = true 
	
func remove_player_from_current_scene():
	#set the pos of current scene before player exits
	#reparent player
	walls.remove_child(player)
	self.add_child(player)
	player = $player
	global.player = player # reset player with global
	pass
	
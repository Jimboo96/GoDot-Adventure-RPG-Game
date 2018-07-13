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
	#print(get_parent().get_child(1).get_name()) #Main	
	#print($Area/area/MoveAreas.is_inside_tree())
	if $Area/area/MoveAreas.is_inside_tree():
		var MoveAreas = get_node("Area/area/MoveAreas")
		var numberOfMoveAreas = MoveAreas.get_child_count()
		var childOfMoveAreas = MoveAreas.get_children()
		for i in numberOfMoveAreas:
			print(childOfMoveAreas[i])
			var moveAreaName = childOfMoveAreas[i].get_name()
			var moveAreaTimer = childOfMoveAreas[i].get_child(1) # return timer
			var timerName = moveAreaTimer.get_name()
			var timerPath = get_node("Area/area/MoveAreas/" + moveAreaName + "/" + timerName) # path to timer
			#print(timerPath)
			if timerPath.is_connected("timeout", $SceneManager, "_on_" + timerName + "_timeout"):
				timerPath.disconnect("timeout", $SceneManager, "_on_" + timerName + "_timeout")
			else:
				timerPath.connect("timeout", $SceneManager, "_on_" + timerName + "_timeout")
			#print("_on_" + timerName + "_timeout")

func goto_area(path):
	conn_signals() #disconnect signals from old area
	remove_player_from_current_scene()
	call_deferred("deferred_goto_scene", path)
	
func deferred_goto_scene(path):
	#load scene
	s = ResourceLoader.load(path)
	#remove old area
	$Area.remove_child(current_area)
	add_new_scene(s)
	pass
	
func add_new_scene(s):
	#load area
	current_area = s.instance()
	#set new var for new area
	area_name = current_area.get_name()  #new name for easy to call during the area is playing
	current_area.set_name("area")
	#add new area
	if $Area.get_child_count() == 0:
		$Area.add_child(current_area)
	#set global area (name)
	global.current_area = area_name
	#connect signals to timer
	conn_signals()
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
	global.player = player
	
func remove_player_from_current_scene():
	#reparent player
	walls.remove_child(player)
	self.add_child(player)
	player = $player
	global.player = player # reset player with global
	pass
	
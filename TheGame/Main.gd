extends Node

var current_area
var area_name #name from node when added to tree

var s = preload("res://areas/area1.tscn")

func _enter_tree():
	current_area = s.instance()
	area_name = current_area.get_name() #area1
	current_area.set_name("area")
	print(area_name)
	print(current_area)
	if $Area.get_child_count() == 0:
		$Area.add_child(current_area)
	print($Area/area/walls/player)
	global.player = $Area/area/walls/player
	global.current_area = area_name
	
func _ready():
	conn_signals()
	
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
			timerPath.connect("timeout", $SceneManager, "_on_" + timerName + "_timeout")
			#print("_on_" + timerName + "_timeout")
			
func disconn_signals(): #called when change scene
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
	pass
func goto_area(path):
	#load scene
	var s = ResourceLoader.load(path)
	#remove old area
	$Area.remove_child(current_area)
	#load area
	current_area = s.instance()
	#set new var for new area
	area_name = current_area.get_name()
	current_area.set_name("area")
	#add new area
	if $Area.get_child_count() == 0:
		$Area.add_child(current_area)
	#set global area
	global.player = $Area/area/walls/player
	global.current_area = area_name
	print(area_name)
	print(current_area)
	conn_signals()
	
	
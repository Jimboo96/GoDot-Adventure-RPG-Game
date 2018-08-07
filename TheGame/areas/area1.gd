<<<<<<< HEAD
extends Node2D
=======
#area1.gd
#spawn at random location at different time
#able to leave only if there is no enemies left
extends "room.gd"
>>>>>>> inventory&master_merge_branch

var ENEMIES = preload("res://enemies/enemy_lv1.tscn")

"""onready var trees = get_node("Trees")
onready var moveAreas = get_node("MoveAreas")
onready var switchAreas = get_node("SwitchAreas")

func _ready():
	print("area1 ready")
	for i in trees.get_child_count():
		trees.get_child(i).set_monitoring(true)
		
	for i in moveAreas.get_child_count():
		moveAreas.get_child(i).set_monitoring(true)
		
	for i in switchAreas.get_child_count():
		if "SwitchArea" in switchAreas.get_child(i).get_name():
			switchAreas.get_child(i).set_monitoring(true)
	pass

#enter area	
func _enter_tree():
	print("area1 enter tree")
	pass
	
#leave area
func _exit_tree():
	print("area1 exit tree")
	for i in trees.get_child_count():
		trees.get_child(i).set_monitoring(false)
		
	for i in moveAreas.get_child_count():
		moveAreas.get_child(i).set_monitoring(false)
		
	for i in switchAreas.get_child_count():
		if "SwitchArea" in switchAreas.get_child(i).get_name():
			switchAreas.get_child(i).set_monitoring(false)
		
	pass"""
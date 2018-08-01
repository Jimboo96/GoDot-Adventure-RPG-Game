extends Node2D

var inventory
var inventoryScene
var inv_location
var inv_bool = true
var player

func _init():
	add_to_group("room")
	inventoryScene = load("res://inventory/Scene_PlayerInventory.tscn")

func inventory_open():
	if inv_bool == true:
		inv_bool = false
		get_tree().paused = true #pause
		spawn_inventory()
	else:
		get_tree().paused = false
		inv_bool = true
		Global_Player.save_data()
		del_inventory()


func spawn_inventory():
	player = get_tree().get_root().get_child(4).get_node("Area/area/walls/YSort/player")
	inv_location = player.global_position
	inventory = inventoryScene.instance()
	add_child(inventory)
	inventory.show()
	inventory
	inventory.rect_global_position = inv_location

func del_inventory():
	if has_node("Node"):
		get_node("Node").free()

func inv_exit_pressed():
	if !inv_bool:
		inv_bool = true
		player.playerMovable =true
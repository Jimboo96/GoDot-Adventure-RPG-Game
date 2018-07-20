# Global_Player.gd

extends Node

var url_PlayerData = "user://PlayerData.bin"
var url_PlayerGear = "user://PlayerGear.bin"
var inventory = {}
var gear = {}
var inventory_maxSlots = 45
var gear_maxSlots = 9
onready var playerData = Global_DataParser.load_data(url_PlayerData)
onready var playerGear = Global_DataParser.load_data(url_PlayerGear)


func _ready():
	load_data()
	load_gear_data()


func load_data():
	if (playerData == null):
		var dict = {"inventory":{}}
		for slot in range (0, inventory_maxSlots):
			dict["inventory"][String(slot)] = {"id": "0", "amount": 0}
		Global_DataParser.write_data(url_PlayerData, dict)
		inventory = dict["inventory"]
	else:
		inventory = playerData["inventory"]


func load_gear_data():
	if (playerGear == null):
		var dict = {"gear":{}}
		for slot in range (0, gear_maxSlots):
			var placeholder = slot+1
			dict["gear"][String(slot)] = {"id": str(placeholder), "amount": 0}
		Global_DataParser.write_data(url_PlayerGear, dict)
		gear = dict["gear"]
	else:
		gear = playerGear["gear"]


func save_data():
	Global_DataParser.write_data(url_PlayerData, {"inventory": inventory})
	Global_DataParser.write_data(url_PlayerGear, {"gear": gear})


func inventory_getEmptySlot():
	for slot in range(0, inventory_maxSlots):
		if (inventory[String(slot)]["id"] == "0"): 
			return int(slot)
	print ("Inventory is full!")
	return -1


#not used for anything?
func gear_getEmptySlot():
	for slot in range(0, gear_maxSlots):
		if (gear[String(slot)]["id"] == "0"): 
			return int(slot)
	print ("gear is full!")
	return -1


func inventory_addItem(itemId):
	var itemData = Global_ItemDatabase.get_item(String(itemId))
	if (itemData == null): 
		return -1
	if (!itemData["stackable"]):
		var slot = inventory_getEmptySlot()
		if (slot < 0): 
			return -1
		inventory[String(slot)] = {"id": String(itemId), "amount": 1}
		return slot
	for slot in range (0, inventory_maxSlots):
		if (inventory[String(slot)]["id"] == String(itemId)):
			inventory[String(slot)]["amount"] = int(inventory[String(slot)]["amount"] + 1)
			return slot
	var slot = inventory_getEmptySlot()
	if (slot < 0): 
		return -1
	inventory[String(slot)] = {"id": String(itemId), "amount": 1}
	return slot


func inventory_addGear(itemId):
	var itemData = Global_ItemDatabase.get_item(String(itemId))
	if (itemData == null): 
		return -1
	if (!itemData["stackable"]):
		var slot = gear_getEmptySlot()
		if (slot < 0): 
			return -1
		gear[String(slot)] = {"id": String(itemId), "amount": 1}
		return slot
		if (gear[String(slot)]["id"] == String(itemId)):
			gear[String(slot)]["amount"] = int(gear[String(slot)]["amount"] + 1)
			return slot
	var slot = gear_getEmptySlot()
	if (slot < 0): 
		return -1
	gear[String(slot)] = {"id": String(itemId), "amount": 1}
	return slot


func inventory_removeItem(slot):
	var newAmount = inventory[String(slot)]["amount"] - 1
	if (newAmount < 1):
		inventory[String(slot)] = {"id": "0", "amount": 0}
		return 0
	inventory[String(slot)]["amount"] = newAmount
	return newAmount


func inventory_removeGear(slot):
	var newAmount = gear[String(slot)]["amount"] - 1
	if (newAmount < 1):
		gear[String(slot)] = {"id": "0", "amount": 0}
		return 0
	gear[String(slot)]["amount"] = newAmount
	return newAmount


func inventory_moveItem(fromSlot, toSlot):
	var temp_ToSlotItem = inventory[String(toSlot)]
	inventory[String(toSlot)] = inventory[String(fromSlot)]
	inventory[String(fromSlot)] = temp_ToSlotItem


func inventory_moveGear(fromSlot, toSlot): 
	var temp_ToSlotItem = gear[String(toSlot)]
	gear[String(toSlot)] = gear[String(fromSlot)]
	gear[String(fromSlot)] = temp_ToSlotItem


func inventory_itemToGear(fromSlot, toSlot):
	var temp_ToSlotItem = gear[String(toSlot)]
	gear[String(toSlot)] = inventory[String(fromSlot)]
	inventory[String(fromSlot)] = temp_ToSlotItem


func inventory_gearToItem(fromSlot, toSlot):
	var temp_ToSlotItem = inventory[String(toSlot)]
	inventory[String(toSlot)] = gear[String(fromSlot)]
	gear[String(fromSlot)] = temp_ToSlotItem


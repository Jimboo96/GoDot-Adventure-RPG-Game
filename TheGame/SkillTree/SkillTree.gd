extends Node

var Ripskill_enabled = false
var Ripskill_upgrade_enabled = false
var Ripskill_sacrifice_enabled = false
var sp = 0
var Lvl = 1
const SAVE_PATH = "user://skillFile.json"
#var _config_file = ConfigFile.new()

var player_skills = {
	Ripskill = Ripskill_enabled,
	Upgrade = Ripskill_upgrade_enabled,
	Sacrifice = Ripskill_sacrifice_enabled
	}

onready var skilltree_scene = preload("res://SkillTree/Stat.tscn")
var skilltree_location = Vector2(0,0)
var skilltree

func _ready():
	_load_points()
#	_save_stats()
	_load_stats()
	sp = (Lvl/2) - _check_enabled_skills()
	_set_sp()
	_enable_true_skills()
	_check_upgrades()

func _on_RipSkillButton_pressed():
	if $RipSkillButton.disabled == false && sp > 0:
		sp -= 1
		$RipSkillButton.disabled = true
		Ripskill_enabled = true
		_set_sp()
		_check_upgrades()
		_save_stats()

func _on_RipSkillButton_mouse_entered():
	$RipSkillButton/WindowDialog.rect_position = $RipSkillButton.rect_position - Vector2(30,-85)
	$RipSkillButton/WindowDialog.show()


func _on_RipSkillButton_mouse_exited():
	$RipSkillButton/WindowDialog.hide()


func _on_Reset_pressed():
	var reset_points = _check_enabled_skills()
	sp += reset_points
	$RipSkillButton.disabled = false
	Ripskill_upgrade_enabled = false
	Ripskill_sacrifice_enabled = false
	Ripskill_enabled = false
	_set_sp()
	_check_upgrades()
	_save_stats()

func _set_sp():
	$Level.text = "Levle: " + str(Lvl)
	$PointsAvailable.text = "Points available: " + str(sp)

func _check_upgrades():
	if Ripskill_enabled == false:
		$RipSkillUpgrade.disabled = true
		$RipSkillUpgrade.texture_normal = load("res://SkillTree/Sprites/upgrade_rip_normal.png")
		$RipSkillUpgrade.texture_hover = load("res://SkillTree/Sprites/upgrade_Rip_hover.png")
	elif Ripskill_enabled == true && sp > 0:
		$RipSkillUpgrade.disabled = false
	if Ripskill_upgrade_enabled == false:
		$RipSkillSacrifice.disabled = true
		$RipSkillSacrifice.texture_normal = load("res://SkillTree/Sprites/Rip_sacrifice_dark.png")
		$RipSkillSacrifice.texture_hover = load("res://SkillTree/Sprites/Rip_sacrifice_hover.png")
	elif Ripskill_upgrade_enabled == true && sp > 0:
		$RipSkillSacrifice.disabled = false

func _enable_true_skills():
	if Ripskill_enabled == true:
		$RipSkillButton.disabled = true
	if Ripskill_upgrade_enabled == true:
		$RipSkillUpgrade.texture_normal = load("res://SkillTree/Sprites/upgrade_rip.png") 
		$RipSkillUpgrade.texture_hover = load("res://SkillTree/Sprites/upgrade_Rip.png")
	if Ripskill_sacrifice_enabled == true:
		$RipSkillSacrifice.texture_normal = load("res://SkillTree/Sprites/Rip_sacrifice.png")
		$RipSkillSacrifice.texture_hover = load("res://SkillTree/Sprites/Rip_sacrifice.png")

func _on_RipSkillUpgrade_mouse_entered():
	$RipSkillUpgrade/UpgradeInfo.rect_position = $RipSkillUpgrade.rect_position - Vector2(30, -85)
	$RipSkillUpgrade/UpgradeInfo.show()


func _on_RipSkillUpgrade_mouse_exited():
	$RipSkillUpgrade/UpgradeInfo.hide()


func _on_RipSkillUpgrade_pressed():
	if sp > 0:
		$RipSkillUpgrade.texture_normal = load("res://SkillTree/Sprites/upgrade_rip.png") 
		$RipSkillUpgrade.texture_hover = load("res://SkillTree/Sprites/upgrade_Rip.png") 
		if Ripskill_upgrade_enabled == false:
			Ripskill_upgrade_enabled = true
			sp -= 1
		elif Ripskill_upgrade_enabled == true:
			pass
	_set_sp()
	_check_upgrades()
	_save_stats()


func _check_enabled_skills():
	if Ripskill_enabled == true && Ripskill_upgrade_enabled == true && Ripskill_sacrifice_enabled == true:
		return 3
	elif Ripskill_enabled == true && Ripskill_upgrade_enabled == true:
		return 2
	elif Ripskill_enabled == true:
		return 1
	else:
		return 0



func _on_RipSkillSacrifice_mouse_entered():
	$RipSkillSacrifice/UpgradeInfo.rect_position = $RipSkillSacrifice.rect_position - Vector2(30, -85)
	$RipSkillSacrifice/UpgradeInfo.show()


func _on_RipSkillSacrifice_mouse_exited():
	$RipSkillSacrifice/UpgradeInfo.hide()


func _on_RipSkillSacrifice_pressed():
	$RipSkillSacrifice.texture_normal = load("res://SkillTree/Sprites/Rip_sacrifice.png")
	$RipSkillSacrifice.texture_hover = load("res://SkillTree/Sprites/Rip_sacrifice.png")
	if Ripskill_sacrifice_enabled == false && sp > 0:
		Ripskill_sacrifice_enabled = true
		sp -= 1
	elif Ripskill_sacrifice_enabled == true:
		print(Ripskill_enabled)
		print(Ripskill_upgrade_enabled)
		print(Ripskill_sacrifice_enabled)
	_set_sp()
	_check_upgrades()
	_save_stats()

func _on_Return_pressed():
	_save_stats()
	skilltree = skilltree_scene.instance()
	add_child(skilltree)
	skilltree.show()
	skilltree.rect_global_position = skilltree_location
	self.queue_free()


func _save_stats():
	var data = player_skills
	
	data.Ripskill = Ripskill_enabled
	data.Upgrade = Ripskill_upgrade_enabled
	data.Sacrifice = Ripskill_sacrifice_enabled
	
	print(data)
	
	var save_file = File.new()
	
	var err = save_file.open_encrypted_with_pass(SAVE_PATH, save_file.WRITE, "mypass")
	save_file.store_line(to_json(data))
	save_file.close()

func _load_stats():
	var current_line = global._load_player_stats(2)
	
	if current_line == null:
		pass
	else:
		print(current_line)
		Ripskill_enabled = current_line["Ripskill"]
		Ripskill_upgrade_enabled = current_line["Upgrade"]
		Ripskill_sacrifice_enabled = current_line["Sacrifice"]


func _exit_tree():
	_save_stats()
	print("skills saved on exit")


func _load_points():
	Lvl = global.player_lvl





















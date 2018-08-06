extends Node

var ap = 0
var constitution = 10
var Str = 1
var Agi = 1
var Wc  = 1
var Lvl = 1
var points_allocated = 0

var position

var player_stats = {
		Str =  Str,
		Agi =  Agi,
		Const = constitution,
		Wc = Wc,
		Ap = ap,
		Pa = points_allocated
	}


var skilltree
var skilltree_scene = preload("res://SkillTree/SkillTree.tscn")

const SAVE_PATH = "user://statFile.json"


func _ready():
#	_save_stats()
	Lvl = global.player_lvl
	_load_stats()
	_set_text()

func _process(delta):
	position = get_tree().get_root().get_child(5).get_node("Area/area/walls/YSort/player").get_child(1).get_camera_screen_center()


func _lvl_up():
	Lvl += 1
	ap += 2
	$Level.text = "Level: " + str(Lvl) 
	set_ap()


func set_ap():
	$Available.text = "Points available: " + str(ap)

func _on_ConstMin_pressed():
	if ap > 0 && constitution > 10:
		ap += 1
		constitution -= 1
		_set_allocated_points(-1)
		$StatContainer/Constitution.text = "Constitution: " + str(constitution)
		set_ap()


func _on_ConstPlus_pressed():
	if ap > 0:
		ap -= 1
		constitution += 1
		_set_allocated_points(1)
		$StatContainer/Constitution.text = "Constitution: " + str(constitution)
		set_ap()


func _on_StrMin_pressed():
	if ap > 0 && Str > 1:
		ap += 1
		Str -= 1
		_set_allocated_points(-1)
		$StatContainer/Strength.text = "Strength: " + str(Str)
		set_ap()


func _on_StrPlus_pressed():
	if ap > 0:
		ap -= 1
		Str += 1
		_set_allocated_points(1)
		$StatContainer/Strength.text = "Strength: " + str(Str)
		set_ap()


func _on_AgiMin_pressed():
	if ap > 0 && Agi > 1:
		ap += 1
		Agi -= 1
		_set_allocated_points(-1)
		$StatContainer/Agility.text = "Agility: " + str(Agi)
		set_ap()


func _on_AgiPlus_pressed():
	if ap > 0:
		ap -= 1
		Agi += 1
		_set_allocated_points(1)
		$StatContainer/Agility.text = "Agility: " + str(Agi)
		set_ap()


func _on_WcMin_pressed():
	if ap > 0 && Wc > 1:
		ap += 1
		Wc -= 1
		_set_allocated_points(-1)
		$StatContainer/Woodcutting.text = "Woodcutting: " + str(Wc)
		set_ap()


func _on_wcPlus_pressed():
	if ap > 0:
		ap -= 1
		Wc += 1
		_set_allocated_points(1)
		$StatContainer/Woodcutting.text = "Woodcutting: " + str(Wc)
		set_ap()


func _on_SkillTree_pressed():
	_save_stats()
	skilltree = skilltree_scene.instance()
	get_parent().add_child(skilltree)
	skilltree.show()
	skilltree.rect_global_position = position - Vector2(325,225)




func _save_stats():
	var data = player_stats
	
	data.Str = Str
	data.Agi = Agi
	data.Const = constitution
	data.Wc = Wc
	data.Ap = ap
	data.Pa = points_allocated
	data.Lvl = global.player_lvl
	
	var save_file = File.new()
	
	var err = save_file.open_encrypted_with_pass(SAVE_PATH, save_file.WRITE, "mypass")
	save_file.store_line(to_json(data))
	save_file.close()


func _load_stats():
	var current_line = global._load_player_stats(1)
	if current_line == null:
		pass
	else:
		print(current_line)
		Str = current_line["Str"]
		Agi = current_line["Agi"]
		constitution = current_line["Const"]
		Wc = current_line["Wc"]
		points_allocated = current_line["Pa"]
		if global.player_lvl == null:
			global.player_lvl = 0
		ap = (global.player_lvl * 2) - points_allocated


func _set_text():
	$StatContainer/Woodcutting.text = "Woodcutting: " + str(Wc)
	$StatContainer/Agility.text = "Agility: " + str(Agi)
	$StatContainer/Strength.text = "Strength: " + str(Str)
	$StatContainer/Constitution.text = "Constitution: " + str(constitution)
	$Available.text = "Points available: " + str(ap)
	$Level.text = "Level: " + str(Lvl) 

func _exit_tree():
	_save_stats()
	print("saved on exit")


func _set_allocated_points(PoM):
	if PoM == 1:
		points_allocated += 1
	elif PoM == -1:
		points_allocated -= 1


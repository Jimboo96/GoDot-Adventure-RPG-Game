extends Control

onready var skilltree_scene = preload("res://SkillTree/Stat.tscn")
var skilltree_location = Vector2(0,0)
var skilltree
var statscreen_active = false
var position
var player

signal emitLvl

func _ready():
	get_parent().get_node("HUD").connect("levelup",self,"emit_lvl")
	
	player = global.find_node_by_name(get_tree().get_root(), "player")

func _process(delta):
	if get_tree().get_root().get_child(5).has_node("Area/area/walls/YSort/player") == false:
		pass
	else:
		position = get_tree().get_root().get_child(5).get_node("Area/area/walls/YSort/player").get_child(1).get_camera_screen_center()


func _open_skilltree():
	skilltree = skilltree_scene.instance()
	add_child(skilltree)
	
	skilltree.show()
	skilltree.rect_global_position = position - Vector2(325,225)

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_P:
			if statscreen_active == false:
				_open_skilltree()
				statscreen_active = true
				get_tree().paused = true
				player.playerMovable = false
			elif statscreen_active == true:
				for i in get_children():
					i.queue_free()
				statscreen_active = false
				get_tree().paused = false
				player.playerMovable = true

func emit_lvl(cur_lvl):
	global.player_lvl = cur_lvl
	print("global player lvl: ", global.player_lvl)



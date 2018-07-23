extends Node

var currentArea
var areaName #name from node when added to tree
var player
var walls

var enemiesIndex = 0
var enemies = Array()
var maxEnemies = 5

var addedFirstArea = false #if first scene loaded (when start game)

var s = preload("res://areas/area1.tscn")

func _enter_tree(): #first enter
	add_new_scene(s)
	$WaitTimeTimer.connect("timeout", self, "enemies_spawning")
	#init signal (player and HUD)
	
func _ready():
	randomize()
	add_player_to_current_scene()
	addedFirstArea = true
	#connect signal for player
	player.connect("attacked", $HUD, "attacked")
	#connect player w HUD
	$HUD/InfoContainer/MainBox/HPBar.currentHP = player.HP
	$HUD/InfoContainer/MainBox/HPBar.connect("updateHP", player, "updateHP")
	$HUD.connect("levelup", player, "levelup")
	
func conn_scenes_signals():
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
			if timerPath.is_connected("timeout", $SceneManager, "_on_" + timerName + "_timeout"):
				timerPath.disconnect("timeout", $SceneManager, "_on_" + timerName + "_timeout") #call when changing scene
			else:
				timerPath.connect("timeout", $SceneManager, "_on_" + timerName + "_timeout")			
		#add signal connection from MoveArea.gd, SwitchAreas.gd to player and remove when change scene.
		if MoveAreas.is_connected("halt_player", player, "_on_MoveAreas_halt_player"):
			MoveAreas.disconnect("halt_player", player, "_on_MoveAreas_halt_player")
		else:
			MoveAreas.connect("halt_player", player, "_on_MoveAreas_halt_player")
		
func goto_area(path):
	$WaitTimeTimer.stop() #called when changing scene
	conn_scenes_signals() #disconnect signals from old area
	remove_player_from_current_scene()
	call_deferred("deferred_goto_area", path)
	
func deferred_goto_area(path):
	global.last_area = global.current_area
	#load scene
	s = ResourceLoader.load(path)
	#remove old area
	$Area.remove_child(currentArea)
	add_new_scene(s)
	pass
	
func add_new_scene(s):
	#load area
	currentArea = s.instance()
	#set new var for new area
	areaName = currentArea.get_name()  #new name for easy to call during the area is playing
	global.current_scene = currentArea
	currentArea.set_name("area")
	#add new area
	#add signals sent to HUD
	currentArea.connect("notify", $HUD, "notify")
	if $Area.get_child_count() == 0:
		$Area.add_child(currentArea)
	#set global area (name)
	global.current_area = areaName	
	walls = currentArea.get_child(2).get_child(0) #/walls/YSort
	#add player to this scene
	if addedFirstArea == true:
		add_player_to_current_scene()
	pass	
	#reset when go to new scene:
	enemiesIndex = 0
	enemies = Array()
	if areaName == "area1":
		maxEnemies = 3
		$WaitTimeTimer.start() #start timer as soon as the scene is added to world
		enemies_spawning()
	if areaName == "area2":
		maxEnemies = 2
		$WaitTimeTimer.start() #start timer as soon as the scene is added to world
		enemies_spawning()
	if areaName == "area3":
		maxEnemies = 4
		$WaitTimeTimer.start() #start timer as soon as the scene is added to world
		enemies_spawning()
		
	
func add_player_to_current_scene():
	print("add player")
	player = $player
	self.remove_child(player)
	walls.add_child(player)
	#walls.set_owner(player)
	player.appear()
	#set new NodePath for player
	player = get_tree().get_root().get_child(1).get_node("Area/area/walls/YSort/player")
	#save to global
	global.player = player
	#connect timer and move areas' signals
	call_deferred("conn_scenes_signals")
	#reset player stage that player can move
	player.playerMovable = true 
	print(player.is_connected("attacked", $HUD, "attacked"))
	
func remove_player_from_current_scene():
	#set the pos of current scene before player exits
	#reparent player
	walls.remove_child(player)
	self.add_child(player)
	player = $player
	global.player = player # reset player with global var
	pass
	
#connect signals from enemies to HUD
func enemies_spawning():
	var enemySetPos = false # to check if 2 enemies appear near together
	if "area" in areaName:
		if enemies.size() < maxEnemies:
			var enemy
			enemy = $Area/area.ENEMIES.instance()
			enemy.set_name("enemy" + str(enemiesIndex))
			walls.add_child(enemy)
			enemy.appear()
			#set location
			#TODO (set pos of enemies to far from each)
			while enemySetPos == false:
				$Area/area/EnemiesPath/EnemiesLocation.set_offset(randi())
				enemy.position = $Area/area/EnemiesPath/EnemiesLocation.position
				if enemies.size() > 0:
					for i in range(0, enemies.size() ):
						if enemy.position.distance_to(enemies[i].position) > 100:
							enemySetPos = true
						else:
							enemySetPos = false
							break
				else:
					break
			#connect signals for each enemy
			enemy.connect("dead", self, "enemies_dead")
			enemy.connect("dead", $HUD, "gain_exp")
			enemy.connect("prize", $HUD, "get_prize")
			enemies.push_back(enemy)
			enemiesIndex = enemiesIndex + 1
			
func enemies_dead(EXP, enemy_id):
	#remove dead enemy from array
	for i in range(0, enemies.size()):
		if (enemy_id.get_name() in enemies[i].get_name()) or (enemies[i].get_name() in enemy_id.get_name()):
			enemies.remove(i)
			break
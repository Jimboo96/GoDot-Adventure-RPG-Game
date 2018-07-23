extends CanvasLayer

signal gainEXP
signal levelup

export (int) var enemies = 3

func _ready():
	#label text
	$LevelUp.hide()
	#connect signals
	conn_signals()
	$Notification.hide()
	
func conn_signals():
	$TextDisappearTimer.connect("timeout", self, "hide_text")
	$InfoContainer/MainBox/LevelBar.connect("levelup", self, "level_up")
	#skill menu
	$SkillButton.connect("pressed", self, "open_popup")
	$SkillMenu/Cancel.connect("pressed", self, "close_popup")

func gain_exp(EXP, enemy_id): #called when an enemy killed, from World
	$InfoContainer/MainBox/LevelBar.update_exp(EXP)
	pass
	
func notify(opt):
	match opt:
		"hearASound":
			$Notification.set_text("You hear something large moving somewhere in the forest....")
		"findAKey":
			$Notification.set_text("You find a key buried under the flower!")
		_:
			pass
	$Notification.show()
	$TextDisappearTimer.set("wait_time", 2)
	$TextDisappearTimer.start()
	pass
	
func attacked(dame):
	$InfoContainer/MainBox/HPBar.attacked(dame)
	
#Level up
func level_up():
	$LevelUp.show()
	$TextDisappearTimer.set("wait_time", 1)
	$TextDisappearTimer.start()
	emit_signal("levelup")
	#for HP Bar
	$InfoContainer/MainBox/HPBar

func hide_text():
	if $LevelUp.is_visible_in_tree():
		$LevelUp.hide()
	if $Notification.is_visible_in_tree():
		$Notification.hide()
		
func get_prize(type, value):
	match type:
		"COIN":
			var cur_coins = int($InfoContainer/MainBox/CoinCounter/Background/Number.text)
			cur_coins = cur_coins + value
			#print(" cur coins : %s " % [cur_coins])
			$InfoContainer/MainBox/CoinCounter/Background/Number.set("text", String(cur_coins))
		_:
			pass
			
func open_popup():
	$SkillMenu.popup()
	pass
	
func close_popup():
	$SkillMenu.hide()
			

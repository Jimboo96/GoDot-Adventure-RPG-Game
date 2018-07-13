extends CanvasLayer

signal gainEXP

export (int) var enemies = 3

func _ready():
	$EnemiesLeft/NumOfEnemies.set("text", String(enemies))	
	#label text
	$InstructionNewRound.hide()
	$LevelUp.hide()
	#connect signals
	conn_signals()
	
func conn_signals():
	$TextDisappearTimer.connect("timeout", self, "hide_text")
	$InfoContainer/MainBox/LevelBar.connect("levelup", self, "level_up")
	#skill menu
	$SkillButton.connect("pressed", self, "open_popup")
	$SkillMenu/Cancel.connect("pressed", self, "close_popup")

func gain_exp(EXP): #called when an enemy killed, from World
	enemy_killed()
	print("gain exp")
	$InfoContainer/MainBox/LevelBar.update_exp(EXP)
	pass
	
func enemy_killed():
	enemies = enemies - 1
	if enemies > 0:
		$EnemiesLeft/NumOfEnemies.set("text", String(enemies))
	else:
		$EnemiesLeft.hide()
		$InstructionNewRound.show()
	pass
	
#Level up
func level_up():
	$LevelUp.show()
	$TextDisappearTimer.start()

func hide_text():
	if $LevelUp.is_visible_in_tree():
		$LevelUp.hide()
		
func get_prize(type, value):
	match type:
		"COIN":
			var cur_coins = int($InfoContainer/MainBox/CoinCounter/Background/Number.text)
			cur_coins = cur_coins + value
			print(" cur coins : %s " % [cur_coins])
			$InfoContainer/MainBox/CoinCounter/Background/Number.set("text", String(cur_coins))
		_:
			pass
			
func open_popup():
	$SkillMenu.popup()
	pass
	
func close_popup():
	$SkillMenu.hide()
			

extends CanvasLayer

signal gainEXP
signal levelup
signal player_dead

func _ready():
	#label text
	$MainText.hide()
	#connect signals
	conn_signals()
	
func conn_signals():
	$TextDisappearTimer.connect("timeout", self, "hide_text")
	$InfoContainer/MainBox/LevelBar.connect("levelup", self, "level_up")
	$InfoContainer/MainBox/HPBar.connect("player_dead", self, "player_dead")
	$WaitTimer.connect("timeout", self, "game_over")
	#skill menu
	#$SkillButton.connect("pressed", self, "open_popup")
	#settings buttons
	$PauseContainer/NinePatchRect/PauseButton.connect("pressed", self, "pause_game")

func gain_exp(EXP, enemy_id): #called when an enemy killed, from World
	$InfoContainer/MainBox/LevelBar.update_exp(EXP)
	pass
	
func attacked(dame):
	$InfoContainer/MainBox/HPBar.attacked(dame)
	
#Level up
func level_up():
	$MainText.set_text("LEVEL UP")
	$MainText.show()
	$TextDisappearTimer.set("wait_time", 1)
	$TextDisappearTimer.start()
	emit_signal("levelup")
	#reset HP for HP Bar
	$InfoContainer/MainBox/HPBar.levelup()
	
func player_dead():
	emit_signal("player_dead")
	$WaitTimer.start()
	
func game_over():	
	$MainText.set_text("GAME OVER")
	$MainText.show()
	$TextDisappearTimer.set("wait_time", 1)
	$TextDisappearTimer.start()
	pass

func hide_text():
	if $MainText.is_visible_in_tree():
		$MainText.hide()
		
	if $MainText.text == "GAME OVER":
		#TODO Handle game over, back to main menu scene, reset stages
		pass
		
func get_prize(type, value):
	match type:
		"COIN":
			var cur_coins = int($InfoContainer/MainBox/Container/CoinCounter/Background/Number.text)
			cur_coins = cur_coins + value
			$InfoContainer/MainBox/Container/CoinCounter/Background/Number.set("text", String(cur_coins))
		_:
			pass
			
"""func open_popup():
	$SkillMenu.popup()
	pass"""

func pause_game():
	#open popup settings
	$PauseMenu.open_menu()
	#pause game
	get_tree().paused = true
	pass
	

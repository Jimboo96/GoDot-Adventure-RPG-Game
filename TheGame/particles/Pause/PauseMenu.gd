extends Container

var gamePause

func _ready():
	hide()
	#open_menu() # for test/debug only
	self.connect("resized", self, "menu_holder_resize")
	$Pause/Menu/MenuContainer/Continue.connect("pressed", self, "continue_game")
	$Pause/Menu/MenuContainer/Settings.connect("pressed", self, "open_settings")
	$Pause/Menu/MenuContainer/Help.connect("pressed", self, "open_help")
	$Pause/Menu/MenuContainer/MainMenu.connect("pressed", self, "open_mainMenu")
	
func menu_holder_resize():
	var current_size = self.get("rect_size")
	$Background.set_region_rect(Rect2(Vector2(0,0), current_size))
	
func init(): #call during open animation
	var screen_size = OS.get_real_window_size()
	var new_pos = Vector2(screen_size.x/2 - 150, screen_size.y/2 -250)
	self.set("rect_position", new_pos )
	pass	
	
func cancel():
	close_settings()
	
func open_menu():
	$PauseMenuAnim.play("open_pause_menu")
	if get_tree().paused == false:
		get_tree().paused = true
	if not self.is_visible_in_tree():
		self.show()
	$Pause.show()

func close_menu():
	$PauseMenuAnim.play("close_pause_menu")
	
func continue_game():
	close_menu()
	
func open_other_menu():
	$Pause.hide()
	
func reset_state(): #call during close animation
	get_tree().paused = false
	self.hide()
	
func open_settings():
	open_other_menu()
	$SettingsMenu.open_menu()
	
func open_help():
	open_other_menu()
	$HelpWindow.open_window()
	#open help window
	pass
	
func open_mainMenu():
	open_other_menu()
	#open confirm quit game box
	$QuitConfirm.open_box()
	pass
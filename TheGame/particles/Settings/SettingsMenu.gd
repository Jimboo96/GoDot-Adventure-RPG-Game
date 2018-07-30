extends Container

onready var fullscreen = Settings.get_setting("display", "fullscreen")
onready var music = Settings.get_setting("audio", "music")
onready var sound = Settings.get_setting("audio", "sound")

func _ready():
	hide()
	self.connect("resized", self, "menu_holder_resize")
	$Menu/ConfirmContainer/OKBtn/OK.connect("pressed", self, "save")
	$Menu/ConfirmContainer/CancelBtn/Cancel.connect("pressed", self, "cancel")
	$Menu/MenuContainer/MenuLines/FullScreen/FullScreenToggle.connect("toggled", self, "fullscreen_tog")
	$Menu/MenuContainer/MenuLines/Music/MusicToggle.connect("toggled", self, "music_tog")
	$Menu/MenuContainer/MenuLines/Sound/SoundToggle.connect("toggled", self, "sound_tog")
	"""TODO changing input keys
	$Menu/MenuContainer/MenuLines/Attack/AttackOpt.connect("item_selected", self, "attack_tog")
	$Menu/MenuContainer/MenuLines/Moving/MoveOpt.connect("item_selected", self, "move_tog")"""
	#open_menu() #for test/debug only
	init()
	
func menu_holder_resize():
	var current_size = self.get("rect_size")
	$Background.set_region_rect(Rect2(Vector2(0,0), current_size))
	
func init(): #call during open animation
	$Menu/MenuContainer/MenuLines/FullScreen/FullScreenToggle.set("pressed", fullscreen)
	$Menu/MenuContainer/MenuLines/Music/MusicToggle.set("pressed", music)
	$Menu/MenuContainer/MenuLines/Sound/SoundToggle.set("pressed", sound)
	pass
	
func save():
	#save scripts to Settings.gd (global)
	Settings.set_setting("audio", "music", music)
	Settings.set_setting("audio", "sound", sound)
	Settings.set_setting("display", "fullscreen", fullscreen)
	Settings.save_settings()
	Settings.load_settings()
	#close
	close_menu()
	if get_parent().get_name() == "PauseMenu":
		get_parent().open_menu() #open pause menu again
	
func cancel():
	close_menu()
	if get_parent().get_name() == "PauseMenu":
		get_parent().open_menu() #open pause menu again
	
func open_menu():
	$SettingsMenuAnim.play("open_settings_menu")
	self.show()
	
func close_menu():
	$SettingsMenuAnim.play("close_settings_menu")
	self.hide()

func fullscreen_tog(if_toggled):
	fullscreen = if_toggled	
	
func music_tog(if_toggled):
	music = if_toggled
	print(if_toggled)
	
func sound_tog(if_toggled):
	sound = if_toggled
	print(if_toggled)
"""TODO changing input keys
	
func attack_tog(id):
	var selected_val = $Menu/MenuContainer/MenuLines/Attack/AttackOpt.get_item_text(id)
	#attack = selected_val
	
func move_tog(id):
	var selected_val = $Menu/MenuContainer/MenuLines/Moving/MoveOpt
	#move = selected_val"""
	

	
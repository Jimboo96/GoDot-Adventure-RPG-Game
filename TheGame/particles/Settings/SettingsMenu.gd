extends Container

var fullscreen = ProjectSettings.get_setting("display/window/size/fullscreen")
var music
var sound

func _ready():
	hide()
	self.connect("resized", self, "menu_holder_resize")
	$Menu/ConfirmContainer/OKBtn/OK.connect("pressed", self, "save")
	$Menu/ConfirmContainer/CancelBtn/Cancel.connect("pressed", self, "cancel")
	$Menu/MenuContainer/MenuLines/FullScreen/FullScreenToggle.connect("toggled", self, "fullscreen")
	
func menu_holder_resize():
	var current_size = self.get("rect_size")
	$Background.set_region_rect(Rect2(Vector2(0,0), current_size))
	
func init():
	var screen_size = OS.get_real_window_size()
	print(screen_size)
	var new_pos = Vector2(screen_size.x/2 - 150, screen_size.y/2 -250)
	print(new_pos)
	self.set("rect_position", new_pos )
	pass
	
func save():
	#save scripts to Settings.gd (global)
	close_settings()
	
func cancel():
	close_settings()
	
func open_settings():
	$AnimationPlayer.play("open_settings_menu")
	self.show()
	
func close_settings():
	$AnimationPlayer.play("close_settings_menu")
	
func reset_state():
	get_tree().paused = false
	self.hide()

func fullscreen(if_toggled):
	fullscreen = if_toggled
	
func music(if_toggled):
	music = if_toggled
	
func sound(if_toggled):
	sound = if_toggled
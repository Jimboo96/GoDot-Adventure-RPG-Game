extends Container

func _ready():
	#hide()
	$Menu/WindowContainer/Container/OKBtn.connect("pressed", self, "close")
	pass

func open_window():
	$HelpWindowAnim.play("open_window")
	self.show()
	
func close_window():
	$HelpWindowAnim.play("close_window")
	self.hide()
	
func close():
	close_window()
	if get_parent().get_name() == "PauseMenu":
		get_parent().open_menu() #open pause menu again
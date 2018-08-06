extends Container

func _ready():
	hide()
	#open_box()
	$CancelBtn.connect("pressed", self, "close_box")
	$BtnContainer/Confirm.connect("pressed", self, "confirm")
	$BtnContainer/Cancel.connect("pressed", self, "close_box")
	
func open_box():
	$BoxAnim.play("open_box")
	self.show()
	pass
	
func confirm():
	$BoxAnim.play("close_box")
	get_tree().paused = false
	self.hide()
	#TODO
	#go to main menu
	#save game
	pass
	
func close_box():
	$BoxAnim.play("close_box")
	get_tree().paused = false
	self.hide()
	pass
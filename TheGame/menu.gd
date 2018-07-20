extends TextureRect

# class member variables go here, for example:
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_StartButton_pressed():
	get_node("/root/global").goto_main("res://main.tscn") 


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_Button_pressed():
	print("TODO make options")

extends Control

onready var viewport = get_viewport()

var minimum_size = Vector2(1024, 600)

func _ready():
	viewport.connect("size_changed", self, "window_resize")
	pass
	
func fade():
	get_node("TransitionEffect").play("fadeEffect")
	
func window_resize():
	var current_size = OS.get_window_size()
	print(current_size)
	print(Vector2(round(current_size.x / 2) - 10, round(current_size.y / 2) - 10))
	if has_node("Sprite"):
		$Sprite.set_region_rect(Rect2(Vector2(0,0), current_size))
		
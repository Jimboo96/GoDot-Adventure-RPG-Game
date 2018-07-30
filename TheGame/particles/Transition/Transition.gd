extends Control

onready var viewport = get_viewport()

signal trans_finished

var minimum_size = Vector2(1024, 600)
var path = ""
var can_trans = false

func _ready():
	viewport.connect("size_changed", self, "window_resize")
	pass
	
func fade(path):
	if not $TransitionEffect.is_connected("animation_finished", self, "trans_finished"):
		$TransitionEffect.connect("animation_finished", self, "trans_finished")
	get_node("TransitionEffect").play("fadeEffect")
	self.path = path
	set_physics_process(true)
	can_trans = true
	
func _physics_process(delta):
	if can_trans == true:
		goto_area(self.path)
		self.path = ""
		
func goto_area(path):
	get_tree().get_root().get_child(4).goto_area(path)
	can_trans = false
	set_physics_process(false)
	
func trans_finished(anim):
	if anim == "fadeEffect":
		return
		emit_signal("trans_finished")
	
func window_resize():
	var current_size = OS.get_window_size()
	print(current_size)
	print(Vector2(round(current_size.x / 2) - 10, round(current_size.y / 2) - 10))
	if has_node("Sprite"):
		$Sprite.set_region_rect(Rect2(Vector2(0,0), current_size))
		
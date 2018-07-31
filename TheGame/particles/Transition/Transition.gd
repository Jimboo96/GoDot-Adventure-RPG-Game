extends Control

onready var viewport = get_viewport()

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
	can_trans = true
	set_physics_process(true)
	
func _physics_process(delta):
	if can_trans == true:
		goto_area(self.path)
		self.path = ""
		
func goto_area(path):
	get_tree().get_root().get_child(2).goto_area(path)
	can_trans = false
	set_physics_process(false)
	
func trans_finished(anim):
	if anim == "fadeEffect":
		if get_tree().get_root().get_node("Main/Sound/WalkingOnLeaves").playing: 
			get_tree().get_root().get_node("Main/Sound/WalkingOnLeaves").stop()
	
func window_resize():
	var current_size = OS.get_window_size()
	if has_node("Sprite"):
		$Sprite.set_region_rect(Rect2(Vector2(0,0), current_size/2))
		
	if current_size.x > 2048:
		$runningCharacter.set("scale", Vector2(0.2,0.2))
		$runningCharacter.set("position", current_size/2)
		
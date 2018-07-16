extends Container

signal monster_dead

onready var tween = $Tween
var cur_HP
var HP = 100

func _ready():
	$lifeBar.set_value(HP)
	hide()
	
#when the attack action of player is emitted
func attacked(damage):
	cur_HP = $lifeBar.get_value()
	#print(HP)
	HP = cur_HP - damage
	update_HP(cur_HP, HP)
	
func update_HP(cur_HP, HP):
	if HP <= 0:
		emit_signal("monster_dead")
		HP = 0
	#TODO with animation
	tween.interpolate_property($lifeBar, "value", cur_HP, HP, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		
func _process(delta):
	$lifeBar.set_value(HP)
	pass

func show_bar(body):
	show()

func hide_bar(body):
	hide()
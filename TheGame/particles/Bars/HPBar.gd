#this is the HP bar of player
extends Container

signal updateHP 
signal player_dead

var maxHP = global.player_max_hp
var currentHP #get value from WorldUpgraded

func _ready():
	#print(currentHP)
	pass

func attacked(damage):
	$Tween.interpolate_property($Gauge, "value", currentHP, currentHP - damage, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	currentHP = currentHP - damage
	emit_signal("updateHP", currentHP)
	if currentHP <= 0:
		emit_signal("player_dead")
	
func levelup():
	maxHP = maxHP * 3/2
	$Tween.interpolate_property($Gauge, "value", currentHP, maxHP, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	currentHP = maxHP
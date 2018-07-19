#this is the HP bar of player
extends Container

signal updateHP 

var currentHP #get value from WorldUpgraded

func _ready():
	#print(currentHP)
	pass

func attacked(damage):
	$Tween.interpolate_property($Gauge, "value", currentHP, currentHP - damage, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	currentHP = currentHP - damage
	#$Gauge.set_value( currentHP )
	emit_signal("updateHP", currentHP)
#this is the HP bar of player
extends Container

signal updateHP 

var currentHP #get value from WorldUpgraded

func _ready():
	#print(currentHP)
	pass

func attacked(damage):
	currentHP = currentHP - damage
	$Gauge.set_value( currentHP )
	emit_signal("updateHP", currentHP)
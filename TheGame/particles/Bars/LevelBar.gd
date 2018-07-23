extends Container

signal levelup

var currentEXP
var maxEXP
var currentLV

func _ready():
	#get values
	currentEXP = int($Gauge.get_value())
	maxEXP = int($"Gauge/Bar Value/Total".text)
	currentLV = int($Level.text)
	#init
	$"Gauge/Bar Value/Value".set_text(String(currentEXP))

func update_exp(EXP):
	var newEXP = currentEXP + int(EXP)
	#set values
	if (newEXP >= maxEXP):
		#anim to max
		$Tween.interpolate_property($Gauge, "value", currentEXP, maxEXP, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
		#set var
		newEXP = newEXP - maxEXP
		currentLV += 1
		maxEXP = maxEXP * 2
		currentEXP = newEXP
		#set values
		$Tween.interpolate_property($Gauge, "value", 0, currentEXP, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.5)
		$Tween.start()
		$Gauge.set("max_value", maxEXP)
		#new level
		#set text
		$Level.set_text(String(currentLV))
		emit_signal("levelup")
	else:
		$Tween.interpolate_property($Gauge, "value", currentEXP, newEXP, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
		currentEXP = newEXP
		pass
		
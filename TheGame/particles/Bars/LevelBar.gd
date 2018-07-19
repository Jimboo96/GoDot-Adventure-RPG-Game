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
	print("update exp")
	currentEXP += int(EXP)
	#set values
	if (currentEXP >= maxEXP):
		#set var
		var newEXP = currentEXP - maxEXP 
		currentLV += 1
		maxEXP = maxEXP * 2
		currentEXP = newEXP
		#set values
		$Gauge.set_value(newEXP)
		$Gauge.set("max_value", maxEXP)
		#new level
		#set text
		#$"Gauge/Bar Value/Value".set_text(String(newEXP))
		#$"Gauge/Bar Value/Total".set_text(String(maxEXP))
		$Level.set_text(String(currentLV))
		emit_signal("levelup")
	else: 
		$Gauge.set_value(currentEXP)
		$"Gauge/Bar Value/Value".set_text(String(currentEXP))
		
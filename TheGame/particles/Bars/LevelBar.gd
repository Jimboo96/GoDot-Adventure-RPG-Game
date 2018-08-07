extends Container

signal levelup

var currentEXP
var maxEXP
var currentLV = 2

func _ready():
	#get values
	currentEXP = int($Gauge.get_value())
	maxEXP = int($"Gauge/Bar Value/Total".text)
	currentLV = global.player_lvl
	printt("current level set to:", currentLV)
	$Level.set_text(String(currentLV))
	
	#init
	$"Gauge/Bar Value/Value".set_text(String(currentEXP))

func update_exp(EXP):
	EXP_drop(int(EXP))
	var newEXP = currentEXP + int(EXP)
	#set values
	if (newEXP >= maxEXP):
		#anim to max
		$Tween.interpolate_property($Gauge, "value", currentEXP, maxEXP, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
		#set var
		newEXP = newEXP - maxEXP
		currentLV += 1
		maxEXP = (maxEXP * currentLV)/2
		currentEXP = newEXP
		#set values
		$Tween.interpolate_property($Gauge, "value", 0, currentEXP, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.5)
		$Tween.start()
		$Gauge.set("max_value", maxEXP)
		#new level
		#set text
		$Level.set_text(String(currentLV))
		emit_signal("levelup", currentLV)
	else:
		$Tween.interpolate_property($Gauge, "value", currentEXP, newEXP, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
		currentEXP = newEXP
		pass

func EXP_drop(var EXP):
	var startPos = Vector2(get_viewport_rect().end.x / 2, get_viewport_rect().end.y / 2)
	$EXPDrop.rect_global_position = startPos
	$EXPDrop.text = "+" + str(EXP) + " XP"
	$EXPDrop.show()

func _physics_process(delta):
	if $EXPDrop.is_visible_in_tree():
		$EXPDrop.rect_global_position.y -= 2
	if $EXPDrop.rect_global_position.y == 0:
		$EXPDrop.hide()
	

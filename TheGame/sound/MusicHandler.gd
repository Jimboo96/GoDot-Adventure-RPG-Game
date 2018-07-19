extends Node2D

var musicIsPlaying = false

func _ready():
	pass

func _process(delta):
	if get_tree().get_current_scene().get_name() == "house1":
		if !musicIsPlaying:
			$TownMusic.play()
			musicIsPlaying = true
	#elif get_tree().get_current_scene().get_name() == "area1":
		#if !musicIsPlaying:
			#$ForestAmbience.play()
			#musicIsPlaying = true

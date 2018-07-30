extends Node2D

var musicIsPlaying = false

# Here we can set the music to play in each area.
func _process(delta):
	if global.current_area == "house1":
		if !musicIsPlaying:
			$TownMusic.play()
			musicIsPlaying = true
	else:
		$TownMusic.stop()
		musicIsPlaying = false

extends MarginContainer

var song_number = 1


func _on_Play_pressed():
	if $MusicPlayer.playing == false:
		var song = load("res://particles/Music/"+String(song_number)+".wav")
		$MusicPlayer.stream = song
		$MusicPlayer.play()
	elif $MusicPlayer.playing == true:
		$MusicPlayer.stop()



func _on_Previous_pressed():
	if song_number == 1:
		song_number = 1
	elif song_number > 1:
		song_number -= 1
	var song = load("res://particles/Music/"+String(song_number)+".wav")
	$MusicPlayer.stream = song
	$MusicPlayer.play()

func _on_Next_pressed():
	if song_number == 19:
		song_number = 9
	elif song_number < 9:
		song_number += 1
	var song = load("res://particles/Music/"+String(song_number)+".wav")
	$MusicPlayer.stream = song
	$MusicPlayer.play()


func _on_MusicPlayer_finished():
	_on_Next_pressed()

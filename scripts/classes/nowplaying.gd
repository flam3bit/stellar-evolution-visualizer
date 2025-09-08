class_name NowPlaying extends AudioStreamPlayer

signal started(title:String)

@export var song_title:String

func play_song(from_position: float = 0.0):
	started.emit(song_title)
	play(from_position)

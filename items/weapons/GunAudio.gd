extends Node2D


var gunshot_audio_players = [AudioStreamPlayer2D.new(), AudioStreamPlayer2D.new()]
var gunshot_sound = load("res://assets/audio/9mm-pistol-shot-6349.mp3")


func _ready() -> void:
	for audio_player in gunshot_audio_players:
		setup_gunshot_audio_player(audio_player)


func setup_gunshot_audio_player(audio_player: AudioStreamPlayer2D) -> void:
	audio_player.stream = gunshot_sound
	audio_player.volume_db = 1
	audio_player.pitch_scale = 1
	add_child(audio_player)


func play_gunshot():
	var played_audio = false

	# Try to play the gunshot sound with an existing audio player
	for audio_player in gunshot_audio_players:
		if not audio_player.is_playing():
			audio_player.play()
			played_audio = true
			break

	# If there wasn't an audio player aviable, create a new one
	if not played_audio:
		gunshot_audio_players.append(AudioStreamPlayer2D.new())
		setup_gunshot_audio_player(gunshot_audio_players[-1])
		gunshot_audio_players[-1].play()

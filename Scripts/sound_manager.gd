extends Node

func create_audio(stream: AudioStream, vol:= 1.0, pitch:= 1.0) -> void:
	var audio:= AudioStreamPlayer.new()
	add_child(audio)
	
	audio.stream = stream
	audio.volume_linear = vol
	audio.pitch_scale = pitch
	
	audio.play()
	
	audio.finished.connect(audio.queue_free)

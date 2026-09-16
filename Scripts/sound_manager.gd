extends Node

var interrupt_audios: Dictionary[AudioStream, AudioStreamPlayer]

func create_audio(stream: AudioStream, vol:= 1.0, pitch:= 1.0) -> AudioStreamPlayer:
	var audio:= AudioStreamPlayer.new()
	add_child(audio)
	
	audio.stream = stream
	audio.volume_linear = vol
	audio.pitch_scale = pitch
	
	audio.play()
	
	audio.finished.connect(audio.queue_free)
	return audio

func create_audio_interrupt(stream: AudioStream, vol:= 1.0, pitch:= 1.0) -> void:
	if stream in interrupt_audios:
		interrupt_audios[stream].stop()
		interrupt_audios[stream].queue_free()
	
	var audio := create_audio(stream, vol, pitch)
	interrupt_audios[stream] = audio
	audio.finished.connect(func() -> void:
		interrupt_audios.erase(stream) )

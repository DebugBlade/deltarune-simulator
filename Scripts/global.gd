extends Node

signal process_30fps(delta: float)

var chapter: int = 1
var restarting: bool = false

var custom_process: float
var custom_process_rate: float = (1 / 30.0)
var custom_process_frames: int
var custom_process_max_steps: int = 8

func _ready() -> void:
	#window integer scaling
	var margin := Vector2(200,200)
	var screen_size := Vector2(DisplayServer.screen_get_size())
	var target_size := (screen_size - margin)
	
	get_window().size *= floor(min(
	(target_size.x / get_window().size.x),
	(target_size.y / get_window().size.y))
	)
	
	get_window().move_to_center()
	
	AudioServer.set_bus_volume_linear(0, 0.25)

func _process(delta: float) -> void:
	_handle_custom_process(delta)

func _handle_custom_process(delta: float) -> void:
	var custom_process_current_steps: int = 0
	custom_process += delta
	
	while custom_process >= custom_process_rate \
	and custom_process_current_steps < custom_process_max_steps:
		custom_process -= (custom_process_rate)
		custom_process_frames += 1
		custom_process_current_steps += 1
		process_30fps.emit(custom_process_rate)
	custom_process_current_steps = 0

func restart() -> void:
	if restarting:
		return
	restarting = true
	get_tree().reload_current_scene.call_deferred()
	await get_tree().create_timer(0.2).timeout
	restarting = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Fullscreen"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if event.is_action_pressed("Restart"):
		restart()

func bankers_round(number: float) -> int:
	var floored: int = floori(number)
	var fraction: float = number - floored
	
	if is_equal_approx(fraction, 0.5):
		return floored if floored % 2 == 0 else floored + 1
	
	return roundi(number)










#

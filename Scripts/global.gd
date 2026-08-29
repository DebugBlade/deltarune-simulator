extends Node

var chapter: int = 1

func _ready() -> void:
	var monitor_size := Vector2(DisplayServer.screen_get_size() - Vector2i(200,200))
	get_window().size *= floor(min((monitor_size.x / get_window().size.x),
	(monitor_size.y / get_window().size.y)))

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Fullscreen"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

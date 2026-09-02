extends Node

var chapter: int = 1

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

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Fullscreen"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

extends Area2D
class_name Bullet

@export var damage: int = 1
@export var destroy_on_hit: bool = true
@export var graze_points: float = 1.0
@export var graze_timepoints: float = 1.0

var grazed: bool


func _ready() -> void:
	var destroyer:= VisibleOnScreenNotifier2D.new()
	add_child(destroyer)
	destroyer.screen_exited.connect(queue_free)
	
func _process(delta: float) -> void:
	pass

func on_player_hit(inv: bool) -> void:
	if destroy_on_hit:
		queue_free()

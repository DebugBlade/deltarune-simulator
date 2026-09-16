class_name AnimatedAfterimage
extends AnimatedSprite2D


var fade_speed: float = 1.2
var scale_speed: float = 0.0
var move_speed := Vector2.ZERO

var acceleration := Vector2.ZERO

func _process(delta: float) -> void:
	modulate.a -= fade_speed * delta
	
	if modulate.a <= 0:
		queue_free()
	
	if scale_speed:
		scale += Vector2(scale_speed, scale_speed) * delta
	
	if acceleration:
		move_speed += acceleration * delta

	if move_speed:
		position += move_speed * delta
	

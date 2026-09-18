class_name ShakeCamera
extends Camera2D

static var current: ShakeCamera

var shake_amount: float = 0
var shake_pos := Vector2.ZERO
var shake_sign: int = 1

func _init() -> void:
	ShakeCamera.current = self

func _process(delta: float) -> void:
	if shake_amount > 0:
		shake_pos = Vector2(shake_amount, shake_amount)
		offset = shake_pos * shake_sign
		shake_sign *= -1
		
		shake_amount -= delta * 30
	
func shake(amount: float = 4.0) -> void:
	shake_amount = amount

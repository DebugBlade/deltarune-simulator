class_name LineEffect
extends TextureRect

const MOVEMENT: int = 35

var direction: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween := create_tween()
	
	tween.set_parallel()
	tween.tween_property(self, "modulate:a", 0.0 , 1.5)
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position:x", position.x + MOVEMENT*direction, 1.5)
	await tween.finished
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

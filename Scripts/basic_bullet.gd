extends Bullet
class_name BasicBullet

@export var speed: float = 120.0

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2.from_angle(rotation)
	
	position += direction * speed * delta

@icon ("res://Assets/EditorIcons/skull.svg")
class_name Monster
extends Character

enum IDS {NONE, JEVIL, SPAMTON, KNIGHT, PINK}

const MAX_MERCY: float = 100.0

@export var id: IDS
@export var description: String

var mercy: float


func _init() -> void:
	add_to_group("Monsters")

func take_damage(damage: int) -> void:
	damage = damage - (defense * 3)
	damage = maxi(damage, 0)
	hp -= damage

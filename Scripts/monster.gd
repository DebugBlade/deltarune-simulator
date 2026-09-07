@icon ("res://Assets/EditorIcons/skull.svg")
class_name Monster
extends Character

enum IDS {NONE, JEVIL, SPAMTON, KNIGHT, PINK}

@export var id: IDS

func take_damage(damage: int) -> void:
	damage = damage - (defense * 3)
	damage = maxi(damage, 0)
	hp -= damage

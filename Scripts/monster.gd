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

func take_damage(damage: int, character: Character) -> void:
	var hero: Hero = character
	damage = damage - (defense * 3)
	damage = maxi(damage, 0)
	hp -= damage
	
	var new_msg: BattleMSG = BattleMSG.SCENE.instantiate()
	new_msg.type = BattleMSG.Type.DAMAGE
	new_msg.modulate = BattleMSG.COLORS[hero.id]
	new_msg.delay = 0.2667
	if damage == 0:
		new_msg.custom_message = BattleMSG.CustomMessage.MISS
	Battle.current.add_child(new_msg)
	new_msg.label.text = str(damage)
	new_msg.global_position = get_center() + Vector2(0, 20)
	new_msg.position.y += 20 - BattleMSG.damage_type_count * 20
	
	hp_changed.emit()

func get_center() -> Vector2:
	var texture: Texture2D = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	var size: Vector2 = texture.get_size() * scale
	var real_offset: Vector2 = sprite.offset * scale
	return (global_position + real_offset) + (size / 2.0)








#

class_name Character
extends AnimatedSprite2D

@export var char_name: String
@export var max_hp: int = 100

var slot: int = -1
var hp: int = 75: set = set_hp

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	hp = roundi(max_hp * 0.75)

func set_hp(new_hp: int) -> void:
	hp = new_hp

func take_damage(damage: int) -> void:
	hp -= damage
	if hp <= 0:
		if animation_player.has_animation("defeated"):
			play_animation("defeated")

func play_animation(animation_name: StringName) -> void:
	assert(animation_player.has_animation(animation_name), "Animation '%s' not found" % animation_name)
	animation_player.play(animation_name)
	play()

class_name Character
extends AnimatedSprite2D

@export var char_name: String

var slot: int = 0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Battle.current.heroes[slot] = self


func _process(delta: float) -> void:
	pass

func play_animation(animation_name: StringName) -> void:
	assert(animation_player.has_animation(animation_name), "Animation '%s' not found" % animation_name)
	animation_player.play(animation_name)

@abstract class_name Character
extends Node2D

@export var char_name: String
@export var max_hp: int = 100

var slot: int = -1
var hp: int = 75: set = set_hp
var attack: int = 6
var defense: int = 4
 
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: AnimatedSprite2D = $Sprite

func _ready() -> void:
	hp = roundi(max_hp * 0.75)
	sprite.animation_changed.connect(_animation_changed)

func set_hp(new_hp: int) -> void:
	hp = new_hp

@abstract func take_damage(damage: int) -> void

func play_animation(animation_name: StringName) -> void:
	assert(animation_player.has_animation(animation_name), "Animation '%s' not found" % animation_name)
	animation_player.play(animation_name)

func _animation_changed() -> void:
	sprite.play()

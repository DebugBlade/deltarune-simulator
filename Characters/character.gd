@abstract class_name Character
extends Node2D

signal hp_changed()

const HIGHLIGHT_SHADER = preload("uid://dsuwsb1muei4f")

@export var char_name: String
@export var max_hp: int = 100

var slot: int = -1
var hp: int = 75: set = set_hp
var attack: int = 18
var defense: int = 4
var shader_material: ShaderMaterial
var highlighted: bool:
	set(state):
		highlight_time = 0.0
		highlighted = state
var highlight_time: float

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: AnimatedSprite2D = $Sprite

func _ready() -> void:
	hp = max_hp
	sprite.animation_changed.connect(_animation_changed)
	shader_material = ShaderMaterial.new()
	shader_material.shader = HIGHLIGHT_SHADER
	sprite.material = shader_material

func _process(delta: float) -> void:
	var highlight_strength: float
	if highlighted:
		highlight_time += delta
		highlight_strength = -cos(highlight_time * 6.0) * 0.4 + 0.6
	else:
		highlight_strength = 0
	shader_material.set_shader_parameter(&"strength", highlight_strength)

func set_hp(new_hp: int) -> void:
	hp = new_hp

@abstract func take_damage(damage: int, character: Character) -> void

func play_animation(animation_name: StringName) -> void:
	assert(animation_player.has_animation(animation_name), "Animation '%s' not found" % animation_name)
	
	animation_player.play(animation_name)
	animation_player.advance(0)

func _animation_changed() -> void:
	if not sprite.is_playing():
		sprite.play()

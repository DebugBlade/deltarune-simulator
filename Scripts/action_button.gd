class_name ActionButton
extends TextureRect

@export var default_texture: Texture2D
@export var hover_texture: Texture2D
@export var ready_texture: Texture2D

@export var type: Hero.ActionType

@export var previous_button: ActionButton
@export var next_button: ActionButton

var hero: Hero

func setup(p_hero: Hero) ->void:
	hero = p_hero
	hero.buttons.set(type, self)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

class_name CharacterTab
extends TextureRect

signal finished

var hero: Hero
var selected: ActionButton
var saved_selected: ActionButton

@onready var battle: Battle = Battle.current
@onready var action_container: HBoxContainer = $Actions/HBoxContainer


func setup(p_hero: Hero) -> void:
	hero = p_hero
	for action: ActionButton in action_container.get_children():
		action.setup(hero)


func _ready() -> void:
	pass


func undo() -> void:
	pass


func handle_input(input: UI.Inputs) -> void:
	match input:
		UI.Inputs.CONFIRM:
			hero.play_animation("xddd")
		UI.Inputs.CANCEL:
			pass
		UI.Inputs.CONFIRM:
			selected = action_container.get_children()[1]
#

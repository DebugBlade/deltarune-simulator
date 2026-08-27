class_name CharacterTab
extends TextureRect

signal finished

var character: Character
var selected: ActionButton
var saved_selected: ActionButton

@onready var battle: Battle = Battle.current
@onready var action_container: HBoxContainer = $Actions/HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func undo() -> void:
	pass

func _unhandled_key_input(event: InputEvent) -> void:
	if battle.focus_tab != self:
		return
	
	if event.is_action_pressed("Accept"):
		accept()
	elif event.is_action_pressed("Cancel"):
		cancel()
	elif event.is_action_pressed("Left"):
		selected = action_container.get_children()[1]
		
func accept() -> void:
	pass

func cancel() -> void:
	pass















#

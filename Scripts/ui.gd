class_name UI
extends CanvasLayer

enum Context {
	DISABLED,
	ACTIONS,
	MAGICS,
	MONSTERS,
	ALLIES,
	ACTS,
}

enum Inputs {
	NONE,
	CONFIRM,
	CANCEL,
	MENU,
	LEFT,
	RIGHT,
	UP,
	DOWN,
}

enum BottomPanel {
	TEXT,
	ALLIES,
	MONSTERS,
}

var context := Context.DISABLED:
	set(new_context):
		if new_context == Context.ACTIONS:
			if not selected_button:
				selected_button = battle.heroes[0].buttons.get(Hero.Action.FIGHT)
		if new_context == Context.MONSTERS:
			change_panel(BottomPanel.MONSTERS)
		context = new_context

var selected_button: ActionButton:
	set(new_button):
		if selected_button:
			selected_button.texture = selected_button.default_texture
		selected_button = new_button
		new_button.texture = new_button.hover_texture
var selected_hero: Hero

@onready var battle: Battle = Battle.current
@onready var bottom_panel: Control = $BattleMenu/BottomPanel


func _unhandled_key_input(event: InputEvent) -> void:
	var input: Inputs = Inputs.NONE
	if event.is_action_pressed("Confirm"):
		if context == Context.ACTIONS:
			if selected_button.type == Hero.Action.FIGHT:
				context = Context.MONSTERS
	elif event.is_action_pressed("Cancel"):
		input = Inputs.CANCEL
	elif event.is_action_pressed("Menu"):
		input = Inputs.MENU
	elif event.is_action_pressed("Left"):
		if context == Context.ACTIONS:
			selected_button = selected_button.previous_button
	elif event.is_action_pressed("Right"):
		if context == Context.ACTIONS:
			selected_button = selected_button.next_button
	elif event.is_action_pressed("Up"):
		input = Inputs.UP
	elif event.is_action_pressed("Down"):
		input = Inputs.DOWN
	else:
		return

	get_viewport().set_input_as_handled()

	if Battle.current.focus_tab:
		Battle.current.focus_tab.handle_input(input)


func change_panel(panel_id: BottomPanel) -> void:
	for panel: Control in bottom_panel.get_children():
		panel.hide()
	(bottom_panel.get_child(panel_id) as Control).show()

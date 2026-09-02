class_name UI
extends CanvasLayer

enum Context {
	DISABLED,
	ACTIONS,
	ALLIES,
	MONSTERS,
	ACTS,
	ITEMS,
	MAGICS,
}

enum BottomPanel {
	TEXT,
	ALLIES,
	MONSTERS,
	ACTS,
	ITEMS,
}

const MENU_MOVE = preload("uid://b38k0k8dyd7wa")
const MENU_SELECT = preload("uid://cu888mwskmipd")

var previous_context := Context.DISABLED
var context := Context.DISABLED:
	set(new_context):
		if new_context == Context.ACTIONS:
			change_panel(BottomPanel.TEXT)
			if not selected_hero:
				selected_hero = battle.first_hero_alive()
		
		elif new_context == Context.ALLIES:
			change_panel(BottomPanel.ALLIES)
		elif new_context == Context.MONSTERS:
			change_panel(BottomPanel.MONSTERS)
		elif new_context == Context.ACTS:
			change_panel(BottomPanel.ACTS)
		elif new_context == Context.ITEMS:
			change_panel(BottomPanel.ITEMS)
		elif new_context == Context.MAGICS:
			change_panel(BottomPanel.ACTS)
		previous_context = context
		context = new_context

var selected_hero: Hero:
	set(new_hero):
		if new_hero:
			selected_button = new_hero.buttons.get(Hero.ActionType.FIGHT)
		else:
			selected_button = null
		selected_hero = new_hero

var selected_button: ActionButton:
	set(new_button):
		if selected_button:
			selected_button.texture = selected_button.default_texture
		if new_button:
			new_button.texture = new_button.hover_texture
		selected_button = new_button

@onready var battle: Battle = Battle.current
@onready var bottom_panel: Control = $BattleMenu/BottomPanel


func _unhandled_key_input(event: InputEvent) -> void:
	if battle.context != Battle.Context.MENU:
		return
		
	get_viewport().set_input_as_handled()
	if event.is_action_pressed("Confirm"):
		if context == Context.ACTIONS:
			if selected_button.type == Hero.ActionType.FIGHT:
				SoundManager.create_audio(MENU_SELECT)
				context = Context.MONSTERS
			elif selected_button.type == Hero.ActionType.ACT:
				SoundManager.create_audio(MENU_SELECT)
				context = Context.ACTS
			elif selected_button.type == Hero.ActionType.ITEM:
				SoundManager.create_audio(MENU_SELECT)
				context = Context.ITEMS
			elif selected_button.type == Hero.ActionType.SPARE:
				SoundManager.create_audio(MENU_SELECT)
				context = Context.MONSTERS
			elif selected_button.type == Hero.ActionType.DEFEND:
				SoundManager.create_audio(MENU_SELECT)
				selected_hero.play_animation("defend")
				selected_hero.char_tab.icon = CharacterTab.Icon.DEFEND
				next_hero()
	elif event.is_action_pressed("Cancel"):
		if context == Context.ACTIONS:
			previous_hero()
		elif previous_context:
			context = previous_context
			SoundManager.create_audio(MENU_MOVE)
	elif event.is_action_pressed("Menu"):
		pass
	elif event.is_action_pressed("Left"):
		if context == Context.ACTIONS:
			SoundManager.create_audio(MENU_MOVE)
			selected_button = selected_button.previous_button
	elif event.is_action_pressed("Right"):
		if context == Context.ACTIONS:
			selected_button = selected_button.next_button
			SoundManager.create_audio(MENU_MOVE)
	elif event.is_action_pressed("Up"):
		pass
	elif event.is_action_pressed("Down"):
		pass
	else:
		return


func previous_hero() -> void:
	if selected_hero == battle.first_hero_alive():
		return
	var new_hero: Hero = battle.heroes.get(selected_hero.slot-1)
	if not new_hero:
		return
	if new_hero.hp <= 0:
		selected_hero = new_hero
		return previous_hero()
	selected_hero.action.reset()
	new_hero.play_animation("idle")
	selected_hero = new_hero

func next_hero() -> void:
	if selected_hero == battle.last_hero_alive():
		return finish_menu()
	var new_hero: Hero = battle.heroes.get(selected_hero.slot+1)
	if new_hero.hp <= 0:
		return next_hero()
	selected_hero = new_hero

func finish_menu() -> void:
	context = Context.DISABLED
	battle.context = Battle.Context.ACTIONS
	selected_hero = null
	selected_button = null

func change_panel(panel_id: BottomPanel) -> void:
	for panel: Control in bottom_panel.get_children():
		panel.hide()
	(bottom_panel.get_child(panel_id) as Control).show()

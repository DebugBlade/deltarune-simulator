class_name UI
extends CanvasLayer

signal attack_finish

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
	NONE = -1,
	TEXT,
	ALLIES,
	MONSTERS,
	ACTS,
	ITEMS,
	ATTACK,
}

const MENU_MOVE = preload("uid://b38k0k8dyd7wa")
const MENU_SELECT = preload("uid://cu888mwskmipd")

const MONSTER_SELECT = preload("uid://qa62ttsvb87g")

static var soul_ui: TextureRect

var previous_context := Context.DISABLED
var context := Context.DISABLED:
	set(new_context):
		previous_context = context
		match new_context:
			Context.DISABLED:
				change_panel(BottomPanel.NONE)
			Context.ACTIONS:
				change_panel(BottomPanel.TEXT)
				if not selected_hero:
					selected_hero = battle.first_hero_alive()
			Context.ALLIES:
				change_panel(BottomPanel.ALLIES)
			Context.MONSTERS:
				change_panel(BottomPanel.MONSTERS)
				selected_selectable = selected_hero.memory.get("monster", monster_list.get_children()[0])
			Context.ACTS:
				change_panel(BottomPanel.ACTS)
			Context.MAGICS:
				change_panel(BottomPanel.ACTS)
			Context.ITEMS:
				change_panel(BottomPanel.ITEMS)
		context = new_context

var selected_hero: Hero:
	set(new_hero):
		if selected_hero:
			selected_hero.char_tab.focused = false
			selected_hero.memory[ActionButton] = selected_button
		if new_hero:
			new_hero.char_tab.focused = true
			selected_button = new_hero.memory.get(ActionButton, new_hero.buttons.get(Hero.ActionType.FIGHT))
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
var selected_selectable: Selectable:
	set(new_select):
		if selected_selectable:
			selected_selectable.focused = false
		if new_select:
			new_select.focused = true
		selected_selectable = new_select

var attacker_index: int = 0

@onready var battle: Battle = Battle.current
@onready var bottom_panel: Control = $BattleMenu/BottomPanel
@onready var monster_list: VBoxContainer = $BattleMenu/BottomPanel/Monsters/MonsterList
@onready var attack_row_holder: VBoxContainer = $BattleMenu/BottomPanel/Attack/AttackRowHolder


func _ready() -> void:
	UI.soul_ui = TextureRect.new()
	UI.soul_ui.texture = preload("uid://de0ojh375qrh0")
	UI.soul_ui.hide()
	if Global.chapter == 1:
		var mercy: Label = $BattleMenu/BottomPanel/Monsters/MERCY
		mercy.hide()


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
				selected_hero.memory["tp"] = battle.add_tp(40)
				selected_hero.action.type = Hero.ActionType.DEFEND
				next_hero()
		elif context == Context.MONSTERS:
			SoundManager.create_audio(MENU_SELECT)
			selected_hero.play_animation("attack_ready")
			selected_hero.char_tab.icon = CharacterTab.Icon.ATTACK
			selected_hero.action.type = Hero.ActionType.FIGHT
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
		match context:
			Context.MONSTERS:
				shift_monster(-1)
	elif event.is_action_pressed("Down"):
		match context:
			Context.MONSTERS:
				shift_monster(1)
	else:
		return


func previous_hero() -> void:
	var slot: int = selected_hero.slot
	while slot > battle.first_hero_alive().slot:
		slot -= 1
		var new_hero: Hero = battle.heroes.get(slot)
		if new_hero and new_hero.hp > 0:
			selected_hero.action.reset()
			new_hero.play_animation("idle")
			new_hero.char_tab.icon = CharacterTab.Icon.NORMAL
			SoundManager.create_audio(MENU_MOVE)
			var tp_used: float = new_hero.memory.get("tp", 0)
			if tp_used:
				new_hero.memory.erase("tp")
				battle.add_tp(-tp_used)
			selected_hero = new_hero
			context = Context.ACTIONS
			break

func next_hero() -> void:
	if selected_hero == battle.last_hero_alive():
		return finish_menu()
	var slot: int = selected_hero.slot
	while slot < battle.last_hero_alive().slot:
		slot += 1
		var new_hero: Hero = battle.heroes.get(slot)
		if new_hero and new_hero.hp > 0:
			selected_hero = new_hero
			context = Context.ACTIONS
			break

func finish_menu() -> void:
	context = Context.DISABLED
	battle.context = Battle.Context.ACTIONS
	selected_hero = null
	selected_button = null

func start_hero_attack() -> void:
	var global_offset: float = 0
	attacker_index = 0
	change_panel(BottomPanel.ATTACK)
	battle.attackers[0].attack_row.active = true
	for attacker: Hero in battle.attackers:
		global_offset += attacker.attack_row.create_bolt(global_offset)
	await attack_finish

func check_next_bolt() -> void:
	attacker_index += 1
	if attacker_index >= battle.attackers.size():
		await get_tree().create_timer(2.0).timeout
		attack_finish.emit()
		return
	var attacker: Hero = battle.attackers[attacker_index]
	attacker.attack_row.active = true
	if attacker.attack_order == 0:
		attacker.attack_row.trigger_attack()
		

func change_panel(panel_id: BottomPanel) -> void:
	for panel: Control in bottom_panel.get_children():
		panel.hide()
	if panel_id != BottomPanel.NONE:
		(bottom_panel.get_child(panel_id) as Control).show()

func shift_monster(amount: int) -> void:
	var monster_select: MonsterSelect = selected_selectable
	var monster_count: int = battle.monsters.size()
	if monster_count > 1:
		selected_selectable = monster_list.get_children() \
		[wrapi(monster_select.monster.slot + amount, 0, monster_count)]
		SoundManager.create_audio(MENU_MOVE)









#

class_name Battle
extends Node2D

enum Context {
	INTRO,
	MENU,
	ACTIONS,
	SOUL_MODE,
}

const CHARACTER_TAB = preload("uid://d2r7lkujy7hml")
const DIAMOND_BULLET = preload("uid://dob2bw60lxpye")
const MAX_TP := 250.0

static var current: Battle

var context: Context:
	set(new_context):
		if context == Context.SOUL_MODE:
			BattleBox.current.dissapear()
			Soul.current.disable()
			for hero in heroes:
				hero.reset()
			
		if new_context == Context.ACTIONS:
			context = new_context
			execute_actions()
			return
		elif new_context == Context.MENU:
			ui.context = ui.Context.ACTIONS
		elif new_context == Context.SOUL_MODE:
			BattleBox.current.appear()
			Soul.current.enable()
			Soul.current.global_position = BattleBox.current.global_position
		context = new_context

var tp: float = 0.0
var attack_timer: float = 0.0
var heroes: Array[Hero] = []
var monsters: Array[Monster] = []
var targets: Array[Character]

@onready var tp_bar: TextureProgressBar = $TPBar
@onready var ui: UI = $UI
@onready var character_tab_holder: HBoxContainer = $UI/BattleMenu/Characters


func _init() -> void:
	Battle.current = self


func _ready() -> void:
	@warning_ignore("unsafe_method_access")
	$Reference.hide()
	BattleBox.current.hide()
	
	var i := 0
	for hero: Hero in get_tree().get_nodes_in_group("Heroes"):
		targets.append(hero)
		heroes.append(hero)
		hero.slot = i
		var tab: CharacterTab = CHARACTER_TAB.instantiate()
		character_tab_holder.add_child(tab)
		tab.setup(hero)
		i += 1
	
	ui.context = ui.Context.ACTIONS
	ui.selected_hero = first_hero_alive()
	context = Context.MENU
	


func _process(delta: float) -> void:
	tp_bar.value = tp / MAX_TP
	@warning_ignore("unsafe_property_access")
	$FPS.text = "FPS: " + str(Engine.get_frames_per_second())

func _physics_process(delta: float) -> void:
	if context == Context.SOUL_MODE:
		attack_timer -= delta
		if attack_timer <= 0:
			context = Context.MENU

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Debug Spawn"):
		var bullet: BasicBullet = DIAMOND_BULLET.instantiate()
		add_child(bullet)
		bullet.global_position = get_global_mouse_position()
		bullet.look_at(Soul.current.position)


func execute_actions() -> void:
	var hero_actions: Dictionary[Hero, Hero.Action]
	for hero in heroes:
		hero_actions.set(hero, hero.action)
	#acts/spells
	for hero in hero_actions:
		var action: Hero.Action = hero_actions[hero]
		if action.type == Hero.ActionType.ACT:
			pass
	#items
	#spare
	#attack
	#defend
	for hero in hero_actions:
		var action: Hero.Action = hero_actions[hero]
		if action.type == Hero.ActionType.DEFEND:
			hero.defending = true
	
	context = Context.SOUL_MODE
	attack_timer = 4.0 #TODO replace with custom attack

func add_tp(plus_tp: float) -> void:
	tp = clampf(tp + plus_tp, 0, MAX_TP)

func first_hero_alive() -> Hero:
	var first_alive: Hero = null
	for hero in heroes:
		if hero and hero.hp > 0:
			first_alive = hero
			break
	return first_alive

func last_hero_alive() -> Hero:
	var last_alive: Hero = null
	var heroes_reversed: Array[Hero] = heroes.duplicate()
	heroes_reversed.reverse()
	for hero in heroes_reversed:
		if hero and hero.hp > 0:
			last_alive = hero
			break
	return last_alive












#

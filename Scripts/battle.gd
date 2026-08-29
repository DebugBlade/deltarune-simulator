class_name Battle
extends Node2D

enum Context {
	INTRO,
	MENU,
	ATTACK,
	ACTION,
}

const CHARACTER_TAB = preload("uid://d2r7lkujy7hml")
const DIAMOND_BULLET = preload("uid://dob2bw60lxpye")
const MAX_TP := 250.0

static var current: Battle

var context: Context:
	set(new_context):
		context = new_context

var tp: float = 0.0
var attack_timer: float = 0.0
var heroes: Array[Hero] = [null, null, null]
var monsters: Array[Monster] = [null, null, null]

var focus_tab: CharacterTab

@onready var tp_bar: TextureProgressBar = $TPBar
@onready var ui: UI = $UI
@onready var character_tab_holder: HBoxContainer = $UI/BattleMenu/Characters


func _init() -> void:
	Battle.current = self


func _ready() -> void:
	var i := 0
	for hero: Hero in get_tree().get_nodes_in_group("Heroes"):
		heroes[i] = hero
		var tab: CharacterTab = CHARACTER_TAB.instantiate()
		character_tab_holder.add_child(tab)
		tab.setup(hero)
		tab.hero = hero
	
	focus_tab = $UI/BattleMenu/Characters/CharacterTab
	ui.context = ui.Context.ACTIONS
	


func _process(delta: float) -> void:
	tp_bar.value = tp / MAX_TP
	@warning_ignore("unsafe_property_access")
	$FPS.text = "FPS: " + str(Engine.get_frames_per_second())


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Debug Spawn"):
		var bullet: BasicBullet = DIAMOND_BULLET.instantiate()

		add_child(bullet)
		bullet.global_position = get_global_mouse_position()
		bullet.look_at(Soul.current.position)


func add_tp(plus_tp: float) -> void:
	tp = min(tp + plus_tp, 100.0)

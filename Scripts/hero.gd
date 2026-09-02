class_name Hero
extends Character

enum ID {NONE, KRIS, SUSIE, RALSEI, NOELLE}

enum ActionType {
	NONE,
	FIGHT,
	ACT,
	ITEM,
	SPARE,
	DEFEND,
}

@export var id: ID
@export var color: Color = Color.WHITE
@export var icon_list: Dictionary[CharacterTab.Icon, Texture2D] = {
	CharacterTab.Icon.NORMAL: null,
	CharacterTab.Icon.ATTACK: null,
	CharacterTab.Icon.ACT: null,
	CharacterTab.Icon.MAGIC: null,
	CharacterTab.Icon.ITEM: null,
	CharacterTab.Icon.SPARE: null,
	CharacterTab.Icon.DEFEND: null,
	CharacterTab.Icon.HURT: null,
}

var defending: bool = false
var action := Action.new()
#var targets: Array[Character]

var char_tab: CharacterTab
var buttons: Dictionary[Hero.ActionType, ActionButton]
var memory: Dictionary

func _init() -> void:
	add_to_group("Heroes")

func set_hp(new_hp: int) -> void:
	super(new_hp)
	if char_tab:
		char_tab.update_hp()

func take_damage(damage: int) -> void:
	hp -= damage
	if char_tab.icon == CharacterTab.Icon.NORMAL:
		char_tab.icon = CharacterTab.Icon.HURT
		wait_hurt_timer()
	if hp <= 0:
		play_animation("defeated")
		hp = round(-max_hp/2.0)

func wait_hurt_timer() -> void:
	await get_tree().create_timer(0.5).timeout
	if Battle.current.context == Battle.Context.SOUL_MODE:
		char_tab.icon = CharacterTab.Icon.HURT

func reset() -> void:
	memory.clear()
	action.reset()
	defending = false
	if hp > 0:
		play_animation("idle")
		char_tab.icon = CharacterTab.Icon.NORMAL

class Action:
	var type: ActionType
	var targets: Array[Character]
	
	func reset() -> void:
		type = ActionType.NONE
		targets = []

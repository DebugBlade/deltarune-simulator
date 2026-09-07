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
@export var can_use_magic: bool = true

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
	if Global.chapter == 1:
		damage = ceili(damage - (defense * 3))
	else:
		var hp_threshold_1: float = max_hp / 5.0
		var hp_threshold_2: float = max_hp / 8.0
		for df_point in defense:
			if damage > hp_threshold_1:
				damage -= 3
			elif damage > hp_threshold_2:
				damage -= 2
			else:
				damage -= 1
	if defending:
		damage = ceili((2 * damage) / 3.0)
	#calculate elemental reduction from:
	#tdamage = ceil(tdamage * scr_element_damage_reduction(__element, global.char[target]));
	
	damage = maxi(damage, 1)
	hp -= damage

	if char_tab.icon == CharacterTab.Icon.NORMAL:
		char_tab.icon = CharacterTab.Icon.HURT
		get_tree().create_timer(0.5).timeout.connect(func() -> void:
			if char_tab.icon == CharacterTab.Icon.HURT:
				char_tab.icon = CharacterTab.Icon.NORMAL)
	if hp <= 0:
		play_animation("defeated")
		hp = round(-max_hp/2.0)
		if Battle.current.first_hero_alive() == null:
			Global.restart() #gameover

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

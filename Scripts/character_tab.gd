class_name CharacterTab
extends Control

signal finished

enum Icon {
	NORMAL,
	ATTACK,
	ACT,
	MAGIC,
	ITEM,
	SPARE,
	DEFEND,
	HURT,
}

const NAME_TEXT: Dictionary[Hero.ID, Texture2D] = {
	Hero.ID.KRIS: preload("uid://85xkxflbxeij"),
	Hero.ID.SUSIE: preload("uid://qo5lo7j24yci"),
	Hero.ID.RALSEI: preload("uid://c4i2ftanqvfr1"),
}

const LINE_EFFECT = preload("uid://dfeykbd1g1w48")
const MAGIC = preload("uid://b2kjaolvm6h73")
const MAGIC_HOVER = preload("uid://cj7lbby0kawbr")

var icon_tween: Tween
var hero: Hero
var selected: ActionButton
var saved_selected: ActionButton
var line_timer: float
var icon: Icon = Icon.NORMAL:
	set(new_icon):
		char_icon.texture = hero.icon_list.get(new_icon)
		icon = new_icon
var focused: bool:
	set(new_state):
		if icon_tween:
			icon_tween.kill()
		icon_tween = create_tween()
		icon_tween.set_parallel()
		icon_tween.set_trans(Tween.TRANS_QUAD)
		icon_tween.set_ease(Tween.EASE_OUT)
		if new_state:
			icon_tween.tween_property(cover, "position:y", -32, 0.233)
			icon_tween.tween_property(top_border_texture, "position:y", 0, 0.233)
			update_borders_color(hero.color)
		else:
			icon_tween.tween_property(cover, "position:y", 0, 0.1)
			icon_tween.tween_property(top_border_texture, "position:y", 32, 0.1)
			update_borders_color(Color.TRANSPARENT)
		focused = new_state

@onready var battle: Battle = Battle.current
@onready var action_container: HBoxContainer = $Actions/HBoxContainer
@onready var line_spawn_left: Control = $Actions/LineSpawnLeft
@onready var line_spawn_right: Control = $Actions/LineSpawnRight
@onready var cover: Panel = $Cover
@onready var hp_bar: ProgressBar = $Cover/HPBar
@onready var hp_text: Label = $Cover/HPText
@onready var max_hp_text: Label = $Cover/MaxHPText
@onready var char_icon: TextureRect = $Cover/Icon
@onready var name_text: TextureRect = $Cover/Name
@onready var top_border_texture: Panel = $TopBorderMask/Texture



func setup(p_hero: Hero) -> void:
	hero = p_hero
	hero.char_tab = self
	update_hp(true)
	for action: ActionButton in action_container.get_children():
		action.setup(hero)
	
	if hero.can_use_magic:
		var magic_button: ActionButton =hero.buttons[Hero.ActionType.ACT]
		magic_button.default_texture = MAGIC
		magic_button.hover_texture = MAGIC_HOVER
		magic_button.texture = MAGIC
	
	icon = Icon.NORMAL
	name_text.texture = NAME_TEXT[hero.id]
	update_borders_color(Color.TRANSPARENT)
	var hp_stylebox := hp_bar.get_theme_stylebox("fill") as StyleBoxFlat
	hp_stylebox.bg_color = hero.color

func _process(delta: float) -> void:
	line_timer += delta
	if line_timer >= 0.5:
		line_timer -= 0.5
		var new_line_l: LineEffect = LINE_EFFECT.instantiate()
		var new_line_r: LineEffect = LINE_EFFECT.instantiate()
		new_line_r.direction = -1
		line_spawn_left.add_child(new_line_l)
		line_spawn_right.add_child(new_line_r)

func update_hp(update_max := false) -> void:
	if update_max:
		hp_bar.max_value = hero.max_hp
		max_hp_text.text = str(hero.max_hp)
	
	hp_bar.value = hero.hp
	hp_text.text = str(hero.hp)
	if hero.hp <= 0:
		hp_text.modulate = Color.WEB_MAROON
		max_hp_text.modulate = Color.WEB_MAROON
	elif hero.hp <= hero.max_hp * 0.25:
		hp_text.modulate = Color.YELLOW
		max_hp_text.modulate = Color.YELLOW

func update_borders_color(color: Color) -> void:
	var border_stylebox := cover.get_theme_stylebox("panel") as StyleBoxFlat
	border_stylebox.border_color = color
	line_spawn_left.modulate = color
	line_spawn_right.modulate = color








#

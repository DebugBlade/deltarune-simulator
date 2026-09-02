class_name CharacterTab
extends TextureRect

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

const LINE_EFFECT = preload("uid://dfeykbd1g1w48")

var hero: Hero
var selected: ActionButton
var saved_selected: ActionButton
var line_timer: float
var icon: Icon = Icon.NORMAL:
	set(new_icon):
		char_icon.texture = hero.icon_list.get(new_icon)
		icon = new_icon

@onready var battle: Battle = Battle.current
@onready var action_container: HBoxContainer = $Actions/HBoxContainer
@onready var line_spawn_left: Control = $Actions/LineSpawnLeft
@onready var line_spawn_right: Control = $Actions/LineSpawnRight
@onready var cover: Panel = $Cover
@onready var hp_bar: ProgressBar = $Cover/HPBar
@onready var hp_text: Label = $Cover/HPText
@onready var max_hp_text: Label = $Cover/MaxHPText
@onready var char_icon: TextureRect = $Cover/Icon


func setup(p_hero: Hero) -> void:
	hero = p_hero
	hero.char_tab = self
	update_hp(true)
	for action: ActionButton in action_container.get_children():
		action.setup(hero)
	var border_stylebox := cover.get_theme_stylebox("panel") as StyleBoxFlat
	border_stylebox.border_color = hero.color
	var hp_stylebox := hp_bar.get_theme_stylebox("fill") as StyleBoxFlat
	hp_stylebox.bg_color = hero.color

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

func _process(delta: float) -> void:
	line_timer += delta
	if line_timer >= 0.5:
		line_timer -= 0.5
		var new_line_l: LineEffect = LINE_EFFECT.instantiate()
		var new_line_r: LineEffect = LINE_EFFECT.instantiate()
		new_line_r.direction = -1
		line_spawn_left.add_child(new_line_l)
		line_spawn_right.add_child(new_line_r)
		new_line_l.self_modulate = hero.color
		new_line_r.self_modulate = hero.color

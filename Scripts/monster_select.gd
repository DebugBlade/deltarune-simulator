class_name MonsterSelect
extends Selectable

var monster: Monster
var slot: int

@onready var hp_bar: ProgressBar = $HPBar
@onready var mercy_bar: ProgressBar = $MercyBar
@onready var hp_percent: Label = $HPBar/HPPercent
@onready var mercy_percent: Label = $MercyBar/MercyPercent

const MONSTER_SELECT = preload("uid://qa62ttsvb87g")

static func create(_monster: Monster) -> MonsterSelect:
	var monster_select: MonsterSelect = MONSTER_SELECT.instantiate()
	monster_select.monster = _monster
	return monster_select

func _ready() -> void:
	label.text = monster.char_name
	update_values()
	if Global.chapter == 1:
			hp_percent.hide()
			mercy_bar.hide()

func update_values() -> void:
	hp_bar.max_value = monster.max_hp
	hp_bar.value = monster.hp
	hp_percent.text = str(roundi((float(monster.hp) / monster.max_hp) * 100.0)) + "%"
	
	mercy_bar.max_value = monster.MAX_MERCY
	mercy_bar.value = monster.mercy
	mercy_percent.text = str(roundi((float(monster.mercy) / monster.MAX_MERCY) * 100.0)) + "%"





#

class_name TPBar
extends Control

static var current: TPBar

const FILL_NEGATIVE = preload("uid://xrlex3ovnbns")
const FILL_POSITIVE = preload("uid://b356sdrb5bqw5")
const COLOR_MAX = Color(1.639, 1.639, 0.814)

var battle: Battle = Battle.current
var tween: Tween
var target_tp: float
var slow_bar: TextureProgressBar

@onready var fill: TextureProgressBar = $Fill
@onready var update_fill: TextureProgressBar = $UpdateFill
@onready var label_percent: Label = $LabelPercent
@onready var label_max: Label = $LabelMAX
@onready var foam: TextureRect = $Fill/Foam


func _init() -> void:
	TPBar.current = self

func _ready() -> void:
	fill.value = 0
	update_fill.value = 0
	foam.position.y = get_foam_position(fill.value)

func _process(delta: float) -> void:
	if fill.value >= fill.max_value:
		label_max.show()
		label_percent.hide()
		fill.self_modulate = COLOR_MAX
	else:
		label_max.hide()
		label_percent.show()
		label_percent.text = "%d\n %%" % floori(fill.value * 100)
		fill.self_modulate = Color.WHITE
	
	if foam.position.y > 183.14: # if very close to the bottom, hide
		foam.hide()
	else:
		foam.show()

	if tween and tween.is_valid() and abs(target_tp - slow_bar.value) < 0.03:
		tween.custom_step(999) # snap if within 3%
		tween.kill()

func update_bar(old_value: float, new_value: float) -> void:
	var max_value: float = battle.MAX_TP
	var percent: float = get_percent(new_value)
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_parallel()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)

	target_tp = percent
	if new_value > old_value:
		slow_bar = fill
		update_fill.texture_progress = FILL_POSITIVE
		tween.tween_property(fill, "value", percent, 0.65)
		tween.tween_property(update_fill, "value", percent, 0.25)
		tween.tween_property(foam, "position:y", get_foam_position(percent), 0.25)
	else:
		slow_bar = update_fill
		update_fill.texture_progress = FILL_NEGATIVE
		tween.tween_property(fill, "value", percent, 0.25)
		tween.tween_property(update_fill, "value", percent, 0.65)
		tween.tween_property(foam, "position:y", get_foam_position(percent), 0.65)

func get_percent(value: float) -> float:
	return value / battle.MAX_TP

func get_foam_position(percent: float) -> float:
	return 187 - (percent * 187) - 2.0

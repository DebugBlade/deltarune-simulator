@icon ("res://Assets/EditorIcons/human.svg")
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

const CRITICAL_POINTS = 150
const CRITICAL_PARTICLE = preload("uid://ylljl0w7dfgu")

@export var id: ID
@export var color: Color = Color.WHITE
@export var secondary_color: Color = Color.WHITE
@export var can_use_magic: bool = true
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
@export var attack_effect: SpriteFrames
@export var attack_pitch: float = 1.0
var defending: bool = false
var action := Action.new()
var attack_order: int
var accuracy_points: float
#var targets: Array[Character]

var attack_row: AttackRow
var char_tab: CharacterTab
var buttons: Dictionary[Hero.ActionType, ActionButton]
var memory: Dictionary
var pos_tween: Tween

@onready var crit_spawn: Node2D = $CritSpawn

func _init() -> void:
	add_to_group("Heroes")

func _ready() -> void:
	super()
	sprite.animation_finished.connect(_on_animation_finished)

func set_hp(new_hp: int) -> void:
	super(new_hp)
	if char_tab:
		char_tab.update_hp()

func take_damage(damage: int, character: Character) -> void:
	var monster: Monster = character
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
	
	ShakeCamera.current.shake()
	if pos_tween:
		pos_tween.kill()
	pos_tween = create_tween()
	var saved_x := position.x
	position.x -= 20
	pos_tween.tween_property(self, "position:x", saved_x, 0.1333)
	
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

func _on_animation_finished() -> void:
	var animation: StringName = sprite.animation
	match animation:
		"attack":
			char_tab.icon = CharacterTab.Icon.NORMAL
			#deal damage

func attack_enemy() -> void:
	const ATTACK_SWING = preload("uid://v0umdylodrtd")
	const ATTACK_CRITICAL_SWING = preload("uid://c6o0tlpbhhtpa")
	var target: Monster = action.targets[0]
	
	SoundManager.create_audio_interrupt(ATTACK_SWING, 1.0, attack_pitch)
	if accuracy_points == CRITICAL_POINTS:
		SoundManager.create_audio_interrupt(ATTACK_CRITICAL_SWING, 1.0, attack_pitch)
		for i in 3:
			var sparkle: AnimatedAfterimage = CRITICAL_PARTICLE.instantiate()
			Battle.current.add_child(sparkle)
			sparkle.move_speed.x = (2 + randf_range(0, 4.0)) * 30.0
			sparkle.acceleration.x = 0.25 * (30 * 30) # double because that's how acceleration works with delta time? this took me hours to figure out sob
			sparkle.position = crit_spawn.global_position + Vector2(randf_range(0, 50.0), randf_range(0, 30.0))
	
	play_animation("attack")
	await get_tree().create_timer(0.334).timeout
	
	var new_effect := AnimatedSprite2D.new()
	new_effect.sprite_frames = attack_effect
	new_effect.scale = Vector2(2.0, 2.0)
	new_effect.play()
	new_effect.animation_finished.connect(new_effect.queue_free)
	Battle.current.add_child(new_effect)
	new_effect.global_position = target.get_center()
	if accuracy_points == CRITICAL_POINTS:
		new_effect.scale = Vector2(2.5, 2.5)
	
	if id == ID.SUSIE:
		ShakeCamera.current.shake()

	var damage: int = Global.bankers_round( (accuracy_points * attack) / 20.0)
	target.take_damage(damage, self)
	
	if damage > 0:
		if target.id == Monster.IDS.JEVIL:
			Battle.current.add_tp(accuracy_points / 15.0)
		else:
			Battle.current.add_tp(accuracy_points / 10.0)

	
func get_size() -> Vector2:
	var texture: Texture2D = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	return texture.get_size() * scale

func get_top_left() -> Vector2:
	if sprite.centered:
		return sprite.global_position - (get_size() / 2) + sprite.offset * sprite.global_scale
	else:
		return sprite.global_position + (sprite.offset * sprite.global_scale)
	
class Action:
	var type: ActionType
	var targets: Array[Character]

	func reset() -> void:
		type = ActionType.NONE
		targets = []

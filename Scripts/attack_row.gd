class_name AttackRow
extends Control

const BOLT_SPEED: int = 240
const BOLT_SCENE = preload("uid://dmprekd2uij8s")
const HIT_MARKERS: Dictionary[Hero.ID, Texture2D] = {
	Hero.ID.KRIS: preload("uid://ci7ynl56l5ge1"),
	Hero.ID.SUSIE: preload("uid://cwhnp2ljn0qpc"),
	Hero.ID.RALSEI: preload("uid://n8u7rxn4oc8d"),
}
const BOLT_TEXTURE = preload("uid://dmrdjupbu1hot")

var hero: Hero
var icon: TextureRect
var bolt_crit_marker: Control 
var hit_marker: TextureRect
var color_timer: float
var border_color: Color:
	set(value):
		hit_area_box.border_color = value
		border_color = value
var active: bool = false
var bolt: Control
var bolt_moving: bool = true
var afterimage_cooldown: float = 0

var custom_process: float
var custom_process_rate: float = (1 / 30.0)

@onready var hit_area: Panel = $HitArea
@onready var hit_area_box: StyleBoxFlat = hit_area.get_theme_stylebox("panel")

func setup(_hero: Hero) -> void:
	hero = _hero
	hero.attack_row = self
	icon = $Icon
	bolt_crit_marker = $BoltCritMarker
	hit_marker = $HitMarker
	hit_marker.texture = HIT_MARKERS[hero.id]
	border_color = hero.secondary_color

	icon.texture = hero.icon_list[CharacterTab.Icon.NORMAL]
	if hero.id == Hero.ID.SUSIE:
		icon.position += Vector2(-2, 1)
	elif hero.id == Hero.ID.RALSEI:
		icon.position += Vector2(-6, -3)
	
	Global.process_30fps.connect(_process_30fps)

func _process(delta: float) -> void:
	if color_timer > 0:
		color_timer = max(0, color_timer - delta)
	border_color = hero.secondary_color.lerp(Color.WHITE, color_timer*6)
	
	if bolt and bolt_moving:
		if afterimage_cooldown <= 0:
			afterimage_cooldown = (2/30.0)
			var afterimage := Afterimage.new(BOLT_TEXTURE)
			add_child(afterimage)
			afterimage.modulate.a = 0.4
			afterimage.position = bolt.position
		afterimage_cooldown -= delta
	
	

func _process_30fps(delta: float) -> void:
	if bolt and bolt_moving:
		bolt.position.x -= BOLT_SPEED * delta
		
		if calculate_accuracy() <= -1:
			bolt.modulate.a = 0
		
		if calculate_accuracy() <= -5:
			trigger_attack()

func create_bolt(global_offset: float) -> float:
	bolt = BOLT_SCENE.instantiate()
	add_child(bolt)
	bolt.add_to_group("Bolts")
	bolt_moving = true
	var self_offset: float = [0, 12, 18][hero.attack_order]
	var offset: float = (30 + self_offset) * (BOLT_SPEED/30.0)
	bolt.position.x = bolt_crit_marker.position.x + offset + global_offset
	bolt.position.y = bolt_crit_marker.position.y
	return self_offset * (BOLT_SPEED/30.0)

func _unhandled_input(event: InputEvent) -> void:
	if active and event.is_action_pressed("Confirm"):
		color_timer = 0.17
		for other_bolt: Control in get_tree().get_nodes_in_group("Bolts"):
			if other_bolt != bolt and abs(bolt.position.x - other_bolt.position.x) < 2:
				(other_bolt.get_parent() as AttackRow).color_timer = 0.17
		if bolt.position.x < 200:
			get_viewport().set_input_as_handled()
			trigger_attack()

func trigger_attack() -> void:
	var target: Monster = hero.action.targets[0]
	var accuracy: int = calculate_accuracy()
	
	
	active = false
	bolt_moving = false
	
	var afterimage := Afterimage.new(BOLT_TEXTURE)
	add_child(afterimage)
	afterimage.fade_speed = 3.0
	afterimage.scale_speed = 6.0
	afterimage.position = bolt.position
	bolt.queue_free()
	
	if accuracy <= -5:
		hero.accuracy_points = 0
		afterimage.queue_free()
	else:
		accuracy = abs(accuracy)
		if accuracy == 0:
			hero.accuracy_points = 150
			afterimage.modulate = Color.YELLOW
			afterimage.scale_speed *= 2
		elif accuracy >= 1 and accuracy <= 2:
			hero.accuracy_points = 130 - accuracy
		elif accuracy >= 3:
			hero.accuracy_points = 100 - (accuracy * 2)
			afterimage.modulate = hero.color.lerp(Color.WHITE, 0.5)
		if accuracy >= 15: #unknown what this for
			afterimage.modulate = hero.color
	
	Battle.current.ui.check_next_bolt()

	while Battle.current.attack_delay:
		await get_tree().process_frame

	Battle.current.attack_delay = true
	get_tree().create_timer(1/30.0).timeout.connect(func()-> void:
		Battle.current.attack_delay = false)
	
	hero.attack_enemy()
	
	
func calculate_accuracy() -> int:
	if bolt:
		print(roundi( abs(bolt.position.x - bolt_crit_marker.position.x) / (BOLT_SPEED/30.0)))
		return roundi( (bolt.position.x - bolt_crit_marker.position.x) / (BOLT_SPEED/30.0))
	return 0





#

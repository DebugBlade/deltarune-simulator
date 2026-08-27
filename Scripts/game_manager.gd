class_name Battle
extends Node2D

static var current: Battle

const DIAMOND_BULLET = preload("uid://dob2bw60lxpye")

@onready var tp_bar: TextureProgressBar = $TPBar

const MAX_TP := 250.0

var TP: float = 0.0
var attack_timer: float = 0.0
var allies: Array = [null, null, null]
var enemies: Array = [null, null, null]

var focus_tab: CharacterTab

func add_tp(plus_tp: float) -> void:
	TP = min(TP + plus_tp, 100.0)

func _init() -> void:
	Battle.current = self 

func _process(delta: float) -> void:
	tp_bar.value = TP / MAX_TP
	$FPS.text = "FPS: " + str(Engine.get_frames_per_second())
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Debug Spawn"):
		var bullet: BasicBullet = DIAMOND_BULLET.instantiate()
		
		add_child(bullet)
		bullet.global_position = get_global_mouse_position()
		bullet.look_at(Soul.current.position)
		

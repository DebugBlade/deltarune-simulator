class_name BattleMSG
extends Control

enum Type {NONE, DAMAGE}
enum CustomMessage {DOWN, GUTS, MAX, MISS, UP}

const SCENE = preload("uid://dn4r03tci2qfb")
static var COLORS: Dictionary[Hero.ID, Color] = {
	Hero.ID.KRIS: Color.AQUA.lerp(Color.WHITE, 0.5),
	Hero.ID.SUSIE: Color.PURPLE.lerp(Color.WHITE, 0.6),
	Hero.ID.RALSEI: Color.LIME.lerp(Color.WHITE, 0.5),
}
const MESSAGES: Dictionary[CustomMessage, Texture2D] = {
	CustomMessage.DOWN: preload("uid://nifryc17v64j"),
	CustomMessage.GUTS: preload("uid://cxjyamqimuvvy"),
	CustomMessage.MAX: preload("uid://bc1y3h02iqk2x"),
	CustomMessage.MISS: preload("uid://br0b1m5gjkb1j"),
	CustomMessage.UP: preload("uid://dflynd66774wi"),
}

static var damage_type_count: int = 0

var type: Type = Type.NONE
var custom_message: CustomMessage

var ystart: float
var stretch_done: bool = false
var stretch: float = 0.2
var kill: float = 0.0
var kill_timer: float = 0.0
var kill_active: bool

var bounces: int = 0
var speed: Vector2
var start_speed_y: float
var lifetime: float
var delay: float = (2 / 30.0)

@onready var label: Label = $Label
@onready var texture_rect: TextureRect = $TextureRect


static func wait_all() -> void:
	for msg: BattleMSG in Global.get_tree().get_nodes_in_group("battle_msg"):
		msg.kill_timer = 0.0

func _ready() -> void:
	add_to_group("battle_msg")
	hide()
	if type == Type.DAMAGE:
		BattleMSG.damage_type_count += 1
	if custom_message:
		label.hide()
		texture_rect.show()
		texture_rect.texture = MESSAGES[custom_message]
	

func _process(delta: float) -> void:
	lifetime += delta
	
	if lifetime >= delay and delay != -1:
		ystart = position.y
		delay = -1
		speed = Vector2(10, -5 - randf_range(0,2)) * 30.0
		start_speed_y = speed.y
		show()
	
	elif delay == -1:
		if not stretch_done:
			stretch += 12.0 * delta
		if stretch >= 1.2:
			stretch = 1
			stretch_done = true
		
		if not is_zero_approx(speed.x):
			speed.x = move_toward(speed.x, 0.0, 900 * delta)
		
		if bounces < 2:
			speed.y += 900 * delta
		if position.y > ystart and bounces < 2 and not kill_active:
			position.y = ystart
			speed.y = start_speed_y / 2.0
			bounces += 1
		if bounces >= 2 and not kill_active:
			speed.y = 0
			position.y = ystart
		
		kill_timer += delta
		if kill_timer > 1.1667:
			kill_active = true
		if kill_active:
			kill += 0.08 * 30 * delta
			position.y -= 120 * delta
		
		position += speed * delta
		
		if kill > 1:
			queue_free()
			if type == Type.DAMAGE:
				BattleMSG.damage_type_count = 0
	
	elif lifetime <= delay:
		BattleMSG.wait_all()
		
		
	
	scale = Vector2(2 - stretch, stretch + kill)
	modulate.a = 1 - kill

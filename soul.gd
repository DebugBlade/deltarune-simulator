extends CharacterBody2D
class_name Soul

static var current: Soul 
var battle: Battle = Battle.current

const SPEED: float = 120.0
var CHAPTER_1_FACTOR: float:
	get(): return 10.0 if Global.chapter == 1 else 0.0

var hp: int = 100
var invincibility_time: float = 1.333
var invincibility_timer: float = 0.0
var graze_timer: float = 0.0
var enabled: bool

var oldpos: Vector2

@onready var hitbox: Area2D = %Hitbox
@onready var graze: Area2D = %Graze
@onready var graze_dark: Sprite2D = $Graze/Dark
@onready var graze_white: Sprite2D = $Graze/White
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

func _ready() -> void:
	hitbox.area_entered.connect(_on_hitbox_area_entered)
	Soul.current = self
	
	hide()
	graze_dark.modulate.a = 0
	graze_white.modulate.a = 0

func _physics_process(delta: float) -> void:
	if not enabled:
		return
	handle_movement(delta)
	handle_graze(delta)
	
	var saved_pos: Vector2 = position
	
	if invincibility_timer > 0:
		invincibility_timer -= delta
		if invincibility_timer <= 0:
			animated_sprite_2d.play("default")
	
	graze_dark.modulate.a = graze_timer / 0.2
	graze_white.modulate.a = (graze_timer / 0.2) - 0.2
	if graze_timer > 0:
		graze_timer -= delta
	
	if move_and_slide():
		# fix wall sliding without having to normalize the direction to be more accurate to deltarune
		position = saved_pos
		handle_movement(delta, true)
		move_and_slide()


func handle_movement(delta: float, normalize:= false) -> void:
	var direction: Vector2 = Vector2( \
	Input.get_axis("Left", "Right"), \
	Input.get_axis("Up","Down") )
	
	if normalize: direction = direction.normalized() * 1.000178 # random number to make speed constant to deltarune if wall sliding
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO

	if Input.is_action_pressed("Cancel"):
		velocity /= 2.0

func handle_graze(delta: float) -> void:
	var bullets: Array[Area2D] = graze.get_overlapping_areas()
	if not bullets:
		return
	for area in bullets:
		if area is Bullet:
			var bullet: Bullet = area
			if invincibility_timer > 0:
				return
			if bullet.grazed:
				battle.add_tp(bullet.graze_points / (30.0 - CHAPTER_1_FACTOR) * 30 * delta)
				if battle.attack_timer >= 1/3.0:
					battle.attack_timer -= bullet.graze_timepoints / (30.0 - CHAPTER_1_FACTOR) * 30 * delta
				if (graze_timer >= 0 and graze_timer < 4/30.0):
					graze_timer = 3/30.0
				if (graze_timer < 2/30.0):
					graze_timer = 2/30.0
			else:
				bullet.grazed = true
				SoundManager.create_audio(preload("uid://dnpdm734gobm6"))
				battle.add_tp(bullet.graze_points)
				graze_timer = 1/3.0
				if battle.attack_timer >= 1/3.0:
					battle.attack_timer -= bullet.graze_timepoints

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area is Bullet:
		var bullet: Bullet = area
		bullet.on_player_hit(true if invincibility_timer > 0 else false)
		if invincibility_timer <= 0:
			hp = hp - bullet.damage
			print(hp)
			invincibility_timer = invincibility_time
			animated_sprite_2d.play("hurt")
			SoundManager.create_audio(preload("uid://c4pg4iqvx3ofl"))


func disable() -> void:
	enabled = false
	hide()

func enable() -> void:
	enabled = true
	show()










#

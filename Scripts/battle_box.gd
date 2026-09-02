class_name BattleBox
extends Node2D

static var current: BattleBox

#unused lol
@onready var top_left: Node2D = $TopLeft
@onready var bottom_right: Node2D = $BottomRight
@onready var l_wall: float = top_left.global_position.x + 12
@onready var r_wall: float = bottom_right.global_position.x - 12
@onready var u_wall: float = top_left.global_position.y + 12
@onready var d_wall: float = bottom_right.global_position.y - 12

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	current = self


func appear() -> void:
	show()
	animated_sprite_2d.play("Start")

func dissapear() -> void:
	animated_sprite_2d.play("End")
	await animated_sprite_2d.animation_finished
	if animated_sprite_2d.animation == "End":
		hide()






#

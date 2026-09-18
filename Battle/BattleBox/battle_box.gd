class_name BattleBox
extends Node2D

static var current: BattleBox

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

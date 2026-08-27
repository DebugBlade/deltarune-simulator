class_name BattleBox
extends Node2D

static var current: BattleBox

@onready var top_left: Node2D = $TopLeft
@onready var bottom_right: Node2D = $BottomRight

@onready var l_wall: float = top_left.global_position.x + 12
@onready var r_wall: float = bottom_right.global_position.x - 12
@onready var u_wall: float = top_left.global_position.y + 12
@onready var d_wall: float = bottom_right.global_position.y - 12

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	current = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

class_name Hero
extends Character

enum Action {
	NONE,
	FIGHT,
	ACT,
	ITEM,
	SPARE,
	DEFEND,
}

var action: Action
var targets: Array[Character]
var buttons: Dictionary[Hero.Action, ActionButton]

func _init() -> void:
	add_to_group("Heroes")

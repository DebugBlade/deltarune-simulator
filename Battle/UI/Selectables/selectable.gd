class_name Selectable
extends Control

@export var label: Label
@export var soul_marker: Control

var focused: bool:
	set(state):
		if state:
			if UI.soul_ui.get_parent():
				UI.soul_ui.get_parent().remove_child(UI.soul_ui)
			add_child(UI.soul_ui)
			UI.soul_ui.global_position = soul_marker.global_position
			UI.soul_ui.show()
		focused = state

func update_values() -> void:
	pass

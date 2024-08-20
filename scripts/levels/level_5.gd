extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProgressStore.disable_all()
	ProgressStore.jump_enabled = true
	ProgressStore.double_jump_enabled = true
	ProgressStore.dash_enabled = true
	ProgressStore.horizontal_scale_enabled = true
	ProgressStore.vertical_scale_enabled = true

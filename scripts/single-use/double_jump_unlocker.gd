extends Node2D

func handle(_node: Player):
	ProgressStore.double_jump_enabled = true
	var label = $"../DoubleJumpLabel"
	create_tween().bind_node(label).set_trans(Tween.TRANS_LINEAR) \
		.tween_property(label, "visible_ratio", 1.0, 3.0)
	$"../EditableLevel/Camera2D".follow_node = $"../DoubleJumpFocusPoint"

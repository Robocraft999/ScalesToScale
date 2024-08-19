extends Node2D

func handle(_node: Player):
	ProgressStore.double_jump_enabled = true
	self.visible = true
	var label = $"../DoubleJumpLabel"
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR) \
		.tween_property($Label, "visible_ratio", 1.0, 1.0)
	tween.chain().set_trans(Tween.TRANS_LINEAR) \
		.tween_property(label, "visible_ratio", 1.0, 3.0)
	$"../EditableLevel/Camera2D".follow_node = $"../DoubleJumpFocusPoint"

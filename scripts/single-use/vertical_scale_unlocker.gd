extends Node2D

func handle(_node: Player):
	var label = $"../VerticalScaleLabel"
	ProgressStore.vertical_scale_enabled
	label.visible_ratio = 0.0
	create_tween().bind_node(label).set_trans(Tween.TRANS_LINEAR) \
		.tween_property(label, "visible_ratio", 1.0, 3.0)

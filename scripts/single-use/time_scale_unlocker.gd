extends Node2D

func handle(_player: Player):
	ProgressStore.time_scale_enabled = true
	$"../NameLabel".visible_ratio = 0.0
	var tween = create_tween().set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_LINEAR)
	
	tween.tween_property($"../NameLabel", "visible_ratio", 1.0, 1.0)
	tween.chain().tween_property($"../ExplanationLabel", "visible_ratio", 1.0, 3.0)

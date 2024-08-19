extends Node2D

func _ready() -> void:
	$ExplanationTriggerArea.body_entered.connect(_trigger_explanation)
	$ExplanationFinishArea.body_entered.connect(_stop_explanation)

func start_animation_finished() -> void:
	%CameraShaker.shake_strength = Vector2(0, 15.0)
	%CameraShaker.shake_decay_rate = 1.0
	await get_tree().create_timer(0.5).timeout
	%CameraShaker.shake_strength = Vector2.ZERO

func handle(_body: Player):
	ProgressStore.horizontal_scale_enabled = true
	$ScaleExplanation/ScaleLabel.visible_ratio = 0.0
	$ScaleExplanation.visible = true
	$EditableLevel/Camera2D.follow_node = $ScaleExplanation
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR).tween_property(
		$ScaleExplanation/ScaleLabel,
		"visible_ratio",
		1.0,
		5.0
	)
	await tween.finished
	$EditableLevel/Camera2D.follow_node = %Player

func _trigger_explanation(body: Node2D):
	if not ProgressStore.horizontal_scale_enabled:
		return
	$ScaleExplanation.hide()
	await get_tree().create_timer(0.5).timeout
	$UsageExplanation.show()
	$EditableLevel/Camera2D.follow_node = $ExampleBox
	create_tween().set_trans(Tween.TRANS_LINEAR).tween_property(
		$UsageExplanation/Label,
		"visible_ratio",
		1.0,
		5.0
	)

func _stop_explanation(body: Node2D):
	$EditableLevel/Camera2D.follow_node = %Player
	$UsageExplanation.hide()
	pass

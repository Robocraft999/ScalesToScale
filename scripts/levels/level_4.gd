extends Node2D

func _ready() -> void:
	ProgressStore.disable_all()
	ProgressStore.jump_enabled = true
	ProgressStore.double_jump_enabled = true
	ProgressStore.horizontal_scale_enabled = true
	ProgressStore.vertical_scale_enabled = true

func handle(_body: Player):
	ProgressStore.dash_enabled = true
	$Scale/NameLabel.visible = true
	$Scale/UsageLabel.visible = true
	var tween = create_tween()
	tween.tween_property($Scale/NameLabel, "visible_ratio", 1.0, 1.0)
	tween.chain().tween_property($Scale/UsageLabel, "visible_ratio", 1.0, 1.0)

extends Node2D

func _ready() -> void:
	$"../VerticalExplanationTriggerArea".body_entered.connect(_explain_trigger)
	pass

func _explain_trigger(body: Node2D):
	if body is Player:
		var label = $"../VerticalScaleLabel"
		create_tween().bind_node(label).set_trans(Tween.TRANS_LINEAR) \
			.tween_property(label, "visible_ratio", 1.0, 3.0)
		pass
	

func handle(_node: Player):
	var label = $Label
	self.visible = true
	ProgressStore.vertical_scale_enabled = true
	label.visible_ratio = 0.0
	create_tween().bind_node(label).set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_LINEAR) \
		.tween_property(label, "visible_ratio", 1.0, 3.0)

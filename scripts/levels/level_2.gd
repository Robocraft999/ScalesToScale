extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TypewriterTrigger.body_entered.connect(_trigger_animation)
	$PlayerRegainFocusArea.body_entered.connect(_regain_player_focus)

func _regain_player_focus(body: Node2D):
	if body is Player:
		$EditableLevel/Camera2D.follow_node = %Player

func _trigger_animation(body: Node2D):
	if body is Player:
		$EditableLevel/Camera2D.follow_node = $EditableLevel/ExampleBox
		$TypewriterAnimationPlayer.play("typewriter_animation")
		$TypewriterTrigger.body_entered.disconnect(_trigger_animation)
	pass

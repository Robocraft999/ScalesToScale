extends Node2D

func _ready() -> void:
	$DoubleJumpExitArea.body_entered.connect(_double_jump_area_exited)
	

func _process(_delta: float) -> void:
	$DoubleJumpFocusPoint.position.y = %Player.position.y
	pass

func _double_jump_area_exited(body: Node2D):
	if body is Player:
		$EditableLevel/Camera2D.follow_node = %Player
		$DoubleJumpExitArea.body_entered.disconnect(_double_jump_area_exited)
		pass

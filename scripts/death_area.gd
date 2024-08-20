extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("Tot haha (You found an easter egg)")
		var player: Player = body
		player.allow_movement = false
		
		if Global.checkpoint_id >= 0:
			Global.timer.stop()
			Global.timer.timeout.emit()
			await SceneLoader.reload_to_checkpoint()
			player.global_position = Global.checkpoint_position
			await SceneLoader.on_transition_ended()
			player.allow_movement = true
		else:
			SceneLoader.reload_current_scene()

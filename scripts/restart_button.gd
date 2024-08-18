extends AnimatedButton

func _on_pressed() -> void:
	SceneLoader.reload_current_scene()

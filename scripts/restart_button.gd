extends Button

func _on_pressed() -> void:
	OptionsManager.get_scene_manager().reload_current_scene()

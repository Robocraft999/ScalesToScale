extends CenterContainer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		visible = not visible
		get_tree().paused = visible
		if visible:
			$VBoxContainer/MainMenu.grab_focus()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not get_rect().has_point(get_global_mouse_position()):
		visible = false
		get_tree().paused = false


func _on_animated_button_pressed() -> void:
	get_tree().paused = false
	SceneLoader.load_level_scene_by_name(Global.SceneName.MAIN_MENU)


func _on_exit_game_pressed() -> void:
	get_tree().quit()

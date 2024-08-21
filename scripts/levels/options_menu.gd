extends CanvasLayer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%EnableScreenshake.button_pressed = Global.enable_screen_shake
	%MasterVolumeslider.value = Global.master_volume
	%MusicVolumeslider.value = Global.music_volume
	%MasterAmountLabel.text = "%s%%" % Global.master_volume
	%MusicAmountLabel.text = "%s%%" % Global.music_volume
	%MenuButton.grab_focus()


func _on_enable_screenshake_toggled(toggled_on: bool) -> void:
	Global.enable_screen_shake = toggled_on


func _on_master_volumeslider_value_changed(value: float) -> void:
	%MasterAmountLabel.text = "%s%%" % value
	Global.master_volume = value
	
func _on_music_volumeslider_value_changed(value: float) -> void:
	%MusicAmountLabel.text = "%s%%" % value
	Global.music_volume = value


func _on_menu_button_pressed() -> void:
	SceneLoader.load_level_scene_by_name(Global.SceneName.MAIN_MENU, false)

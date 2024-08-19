extends CanvasLayer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%EnableScreenshake.button_pressed = Global.enable_screen_shake
	%Volumeslider.value = Global.volume
	%AmountLabel.text = "%s%%" % Global.volume


func _on_enable_screenshake_toggled(toggled_on: bool) -> void:
	Global.enable_screen_shake = toggled_on


func _on_volumeslider_value_changed(value: float) -> void:
	%AmountLabel.text = "%s%%" % value
	Global.volume = value


func _on_menu_button_pressed() -> void:
	SceneLoader.load_level_scene_by_name(Global.SceneName.MAIN_MENU, false)

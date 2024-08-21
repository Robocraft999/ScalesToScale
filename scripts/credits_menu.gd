extends Control

func _ready() -> void:
	%MenuButton.grab_focus()

func _on_menu_button_pressed() -> void:
	SceneLoader.load_level_scene_by_name(Global.SceneName.MAIN_MENU, false)

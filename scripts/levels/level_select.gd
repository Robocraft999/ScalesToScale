extends Node

func _ready() -> void:
	$CanvasLayer/CenterContainer/VBoxContainer/Tutorial.grab_focus()

func _on_back_pressed() -> void:
	SceneLoader.load_level_scene_by_name(OptionsManager.SceneName.MAIN_MENU, false)


func _on_tutorial_pressed() -> void:
	SceneLoader.load_level_scene_by_name(OptionsManager.SceneName.TUTORIAL)


func _on_level_1_pressed() -> void:
	SceneLoader.load_level_scene_by_name(OptionsManager.SceneName.LEVEL1)


func _on_level_2_pressed() -> void:
	print("TODO: missing Level 2 or SceneName entry")


func _on_level_3_pressed() -> void:
	print("TODO: missing Level 3 or SceneName entry")


func _on_level_4_pressed() -> void:
	print("TODO: missing Level 4 or SceneName entry")


func _on_level_5_pressed() -> void:
	print("TODO: missing Level 5 or SceneName entry")


func _on_level_6_pressed() -> void:
	print("TODO: missing Level 6 or SceneName entry")


func _on_test_pressed() -> void:
	SceneLoader.load_level_scene_by_name(OptionsManager.SceneName.TEST)

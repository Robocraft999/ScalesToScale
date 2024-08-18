extends Node

func _ready() -> void:
	SceneLoader.load_level_scene_by_name(Global.SceneName.MAIN_MENU, false)

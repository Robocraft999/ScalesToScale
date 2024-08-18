extends Node

@onready var scene_manager: SceneManager = $"../root/SceneManager"
var scene_manager_scene = preload("res://scenes/objects/scene_manager.tscn")
#var main_menu_scene = preload("res://scenes/main_menu.tscn")

func get_scene_manager() -> SceneManager:
	if not scene_manager:
		get_tree().change_scene_to_file("res://scenes/root.tscn")
		
		# Doesn't work, because SceneManager can't unload current Scene
		#scene_manager = scene_manager_scene.instantiate()
		#scene_manager.populate_loadable_scenes_list()
		#get_tree().root.add_child(scene_manager)
		#scene_manager = $"/root/SceneManager"
	return scene_manager

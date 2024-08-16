extends Node
class_name SceneManager

@export var editor_scenes : Array[PackedScene];
var loadable_scenes : Array[LoadableScene];
var current_scene : LoadedScene;

func _ready() -> void:
	populate_loadable_scenes_list()
	load_level_scene_by_index(0);

func populate_loadable_scenes_list():
	for scene in editor_scenes:
		add_level_scene_to_scene_array(scene);
		
func load_level_scene_by_index(scene_index : int):
	if(scene_index < 0 || scene_index > loadable_scenes.size()):
		return null;
	
	return load_level_scene(loadable_scenes[scene_index], scene_index);

func load_level_scene_by_name(scene_name : String):
	var i : int = 0;
	while i < loadable_scenes.size():
		if(scene_name == loadable_scenes[i].scene_name):
			return load_level_scene(loadable_scenes[i], i);
		i += 1;

	return null;

func load_level_scene(scene_to_load : LoadableScene, scene_index : int):
	if(!scene_to_load.scene.can_instantiate()):
		return null;

	if(current_scene != null):
		current_scene.scene.queue_free();
		current_scene = null;

	var new_scene : Node = scene_to_load.scene.instantiate();

	if(new_scene == null):
		return null;

	current_scene = LoadedScene.new();

	current_scene.scene = new_scene;
	current_scene.scene_index = scene_index;
	current_scene.scene_name = scene_to_load.scene_name;

	get_tree().root.add_child.call_deferred(new_scene);

	#print(new_scene);

	return current_scene;
	
func reload_current_scene():
	load_level_scene_by_index(current_scene.scene_index)
		
func add_level_scene_to_scene_array(scene):
	if(scene == null):
		return -1;
	
	var scene_name : String = scene._bundled["names"][0];

	#print(scene_name);
	
	var i : int = 0;

	while i < loadable_scenes.size():
		if(scene_name == loadable_scenes[i].scene_name):
			printerr("Duplicate scenes with the name: " + name);
			return -1;
		i += 1;

	var loadable_scene : LoadableScene = LoadableScene.new();

	loadable_scene.scene_name = scene_name;
	loadable_scene.scene = scene;

	loadable_scenes.append(loadable_scene);

	return loadable_scenes.size() - 1;

	
class LoadedScene:

	var scene_index : int;
	var scene_name : String;
	var scene : Node;



class LoadableScene:

	var scene_name : String;
	var scene : PackedScene;

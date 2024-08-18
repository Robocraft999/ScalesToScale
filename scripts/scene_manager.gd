extends Node
class_name SceneManager

@export var editor_scenes : Array[PackedScene];
@onready var transition_scene = preload("res://scenes/transition.tscn").instantiate()
var loadable_scenes : Array[LoadableScene];
var current_scene : LoadedScene;

func _ready() -> void:
	editor_scenes = Global.get_all_scenes_in_folder("res://scenes")
	editor_scenes.append_array(Global.get_all_scenes_in_folder("res://scenes/levels"))
	populate_loadable_scenes_list()
	
	get_tree().root.add_child.call_deferred(transition_scene)

func populate_loadable_scenes_list():
	for scene in editor_scenes:
		add_level_scene_to_scene_array(scene);
		
func load_level_scene_by_index(scene_index : int, should_use_transition: bool = true):
	if(scene_index < 0 || scene_index > loadable_scenes.size()):
		return null;
	
	return await load_level_scene(loadable_scenes[scene_index], scene_index, should_use_transition);

func load_next_level_scene():
	return await load_level_scene_by_index((current_scene.scene_index + 1) % editor_scenes.size())

func load_level_scene_by_name(scene_name : String, should_use_transition: bool = true):
	var i : int = 0;
	while i < loadable_scenes.size():
		if(scene_name == loadable_scenes[i].scene_name):
			return await load_level_scene(loadable_scenes[i], i, should_use_transition);
		i += 1;

	return null;

func load_level_scene(scene_to_load : LoadableScene, scene_index : int, should_use_transition: bool):
	if(!scene_to_load.scene.can_instantiate()):
		return null;
		
	if should_use_transition:
		transition_scene.start()
		await transition_scene.half_done

	if(current_scene != null):
		current_scene.scene.queue_free();
		current_scene = null;
	else:
		if get_tree().current_scene != null:
			get_tree().current_scene.queue_free()

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
	if current_scene == null:
		load_level_scene_by_name(get_tree().current_scene.name)
	else:
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

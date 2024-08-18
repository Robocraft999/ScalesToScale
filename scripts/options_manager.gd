extends Node

var enable_screen_shake := true
var time_scale = 1

const SceneName  = {
	MAIN_MENU = "MainMenu",
	TUTORIAL = "Tutorial0",
	TEST = "test",
	LEVEL1 = "Level 1",
	LEVEL2 = "Level 2",
	LEVEL_SELECT = "level_select"
}

func _ready() -> void:
	for scene: PackedScene in get_all_in_folder("res://scenes/levels"):
		print(scene.resource_path)
	
func get_all_scenes_in_folder(path) -> Array[PackedScene]:
	var wrapped: Array[PackedScene] = []
	for resource: PackedScene in get_all_in_folder(path):
		wrapped.append(resource)
	return wrapped

func get_all_in_folder(path):
	var items = []
	var dir = DirAccess.open(path)
	if not dir:
		push_error("Invalid dir: " + path)
		return items  # Return an empty list if the directory is invalid

	# print("Opening directory: ", path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		# print("Found file: ", file_name)
		if !file_name.begins_with(".") and !file_name.ends_with(".import") and not dir.current_is_dir():
			var full_path = path + "/" + file_name
			# Remove .remap extension if present
			if full_path.ends_with(".remap"):
				full_path = full_path.substr(0, full_path.length() - 6)
			# print("Checking path: ", full_path)
			if ResourceLoader.exists(full_path):
				# print("Path exists: ", full_path)
				var res = ResourceLoader.load(full_path)
				if res:
					# print("Loaded resource: ", full_path)
					items.append(res)
				else:
					push_error("Failed to load resource: ", full_path)
			else:
				push_error("Resource does not exist: ", full_path)
		file_name = dir.get_next()
	dir.list_dir_end()
	return items

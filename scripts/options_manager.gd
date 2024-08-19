extends Node

var enable_screen_shake := true
var time_scale = 1
var time_scale_timer: SceneTreeTimer
@onready var timer: Timer = preload("res://scenes/objects/timer.tscn").instantiate()

const SceneName  = {
	MAIN_MENU = "MainMenu",
	TUTORIAL = "Tutorial0",
	TEST = "test",
	LEVEL1 = "Level 1",
	LEVEL2 = "Level 2",
	LEVEL3 = "Level 3",
	LEVEL_SELECT = "level_select"
}

func _ready() -> void:
	for scene: PackedScene in get_all_in_folder("res://scenes/levels"):
		print(scene.resource_path)
	get_tree().root.add_child.call_deferred(timer)
		
func _process(delta: float) -> void:
	if ProgressStore.time_scale_enabled:
		if Input.is_action_just_pressed("toggle_time_scale") and timer.is_stopped():
			time_scale = 0.25
			timer.start(10)
			timer.timeout.connect(func(): time_scale = 1)
		
func lerp(from: Vector2, to: Vector2, weight: Vector2) -> Vector2:
	return Vector2(lerp(from.x, to.x, weight.x), lerp(from.y, to.y, weight.y))
	
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

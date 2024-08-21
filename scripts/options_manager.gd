extends Node

# Options
var enable_screen_shake := true
var master_volume := 80.0
var music_volume := 5.0
var is_menu_music

# Time Scale stuff
var time_scale = 1
@onready var timer: Timer = preload("res://scenes/objects/timer.tscn").instantiate()

# checkpoints
var checkpoint_id = -1
var checkpoint_position = Vector2.ZERO

# Box Selection
var visible_boxes: Array[Scaler] = []
var current_box_index = 0
var current_select_cooldown = 0
var max_select_cooldown = 0.15

const SceneName  = {
	MAIN_MENU = "MainMenu",
	TUTORIAL = "Tutorial0",
	OPTIONS = "options_menu",
	TEST = "test",
	CREDITS = "credits",
	LEVEL1 = "Level 1",
	LEVEL2 = "Level 2",
	LEVEL3 = "Level 3",
	LEVEL4 = "Level 4",
	LEVEL5 = "Level 5",
	LEVEL6 = "Level 6",
	LEVEL_SELECT = "level_select"
}

func _ready() -> void:
	get_tree().root.add_child.call_deferred(timer)
		
func _process(delta: float) -> void:
	if ProgressStore.time_scale_enabled:
		if Input.is_action_just_pressed("toggle_time_scale") and timer.is_stopped():
			time_scale = 0.25
			timer.start(10)
			timer.timeout.connect(func(): time_scale = 1)
			
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_volume/100.0))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_volume/100.0))
	
	var is_menu := SceneLoader.current_scene.scene_name in [SceneName.OPTIONS, SceneName.MAIN_MENU, SceneName.LEVEL_SELECT, SceneName.CREDITS]
	if is_menu != is_menu_music:
		is_menu_music = is_menu
		var menu: AudioStreamPlayer =  MusicPlayer.get_child(0)
		menu.playing = is_menu_music
		var game: AudioStreamPlayer =  MusicPlayer.get_child(1)
		game.playing = not is_menu_music
		
	if current_select_cooldown <= 0:
		var box_select_dir = Input.get_axis("box_cycle_left", "box_cycle_right")
		if box_select_dir != 0 and not is_menu and visible_boxes.size() > 0:
			current_box_index = (visible_boxes.size() + current_box_index + int(box_select_dir)) % visible_boxes.size()
			current_select_cooldown = max_select_cooldown
	else:
		current_select_cooldown -= delta
		
		
func lerp(from: Vector2, to: Vector2, weight: Vector2) -> Vector2:
	return Vector2(lerp(from.x, to.x, weight.x), lerp(from.y, to.y, weight.y))
	
func select_scaler(scaler: Scaler):
	for i in range(visible_boxes.size()):
		if visible_boxes[i] == scaler:
			current_box_index = i
			break
			
#TODO add unselect box

func add_scaler(scaler: Scaler):
	visible_boxes.append(scaler)

func remove_scaler(scaler: Scaler):
	var remove_index = -1
	for i in range(visible_boxes.size()):
		if visible_boxes[i] == scaler:
			remove_index = i
			break
	if remove_index >= 0:
		if remove_index < current_box_index:
			current_box_index -= 1
		elif remove_index == current_box_index and current_box_index == visible_boxes.size() - 1:
			current_box_index = 0
		visible_boxes.remove_at(remove_index)
	

func is_scaler_selected(scaler: Scaler) -> bool:
	if visible_boxes.is_empty():
		return false
	return visible_boxes[current_box_index] == scaler
	
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

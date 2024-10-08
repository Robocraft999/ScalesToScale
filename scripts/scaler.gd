extends Node2D
class_name Scaler

@export var MAX_SCALE = Vector2(5.0, 5.0)

@export var target_offset := Vector2.ZERO
@export var step_step := Vector2.ONE
var current_offset = target_offset
var new_scale     := Vector2.ONE

@export var retraction_direction := Vector2.DOWN

@onready var parent: CollisionObject2D = $".."
@onready var sprite: Sprite2D = $"../Sprite2D"
@onready var sprite_region_size: Vector2 = sprite.region_rect.size
@onready var collider_size: Vector2 = parent.get_child(0).shape.get_rect().size
@onready var STEP = Vector2.ONE / (MAX_SCALE - Vector2.ONE)

var toggled = false

var scaleTween: Tween
var positionTween: Tween
var sprite_rect_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scaleTween = create_tween()
	positionTween = create_tween()
	sprite_rect_tween = create_tween()
	scaleTween.tween_interval(0.1)
	positionTween.tween_interval(0.1)
	sprite_rect_tween.tween_interval(0.1)
	scaleTween.stop()
	positionTween.stop()
	sprite_rect_tween.stop()
	
	get_tree().create_timer(1).timeout.connect(
		func(): 
		if target_offset != Vector2.ZERO:
			calculate_new_scale()
			try_scale()
		)

func is_tweening():
	return scaleTween.is_running() or positionTween.is_running()

func calculate_new_scale():
	new_scale = Global.lerp(Vector2.ONE, MAX_SCALE, target_offset)

func _physics_process(delta: float) -> void:
	# if mouse is in body
	if Global.is_scaler_selected(self):
		# What axis are we editing?
		if Input.is_action_just_pressed("scale_toggle"):
			toggled = not toggled
		if toggled and ProgressStore.vertical_scale_enabled:
			$yArrow.visible = true
			$xArrow.visible = false
		elif not toggled and ProgressStore.horizontal_scale_enabled:
			$yArrow.visible = false
			$xArrow.visible = true
		
		if not is_tweening():
			
			# Store last offset in variable
			# The last target offset is now the current offset
			current_offset = target_offset
			
			# Calculate new desired offset
			if Input.is_action_just_released("mouse_wheel_up"):
				if toggled and ProgressStore.vertical_scale_enabled:
					target_offset.y += STEP.y * step_step.y
				elif not toggled and ProgressStore.horizontal_scale_enabled:
					target_offset.x += STEP.x * step_step.x
			elif Input.is_action_just_released("mouse_wheel_down"):
				if toggled and ProgressStore.vertical_scale_enabled:
					target_offset.y -= STEP.y * step_step.y
				elif not toggled and ProgressStore.horizontal_scale_enabled:
					target_offset.x -= STEP.x * step_step.x
			
			# At most one entire step per 'frame'
			target_offset.x = clamp(target_offset.x, 0, 1)
			target_offset.y = clamp(target_offset.y, 0, 1)
			
			# current_offset now holds the desired absolute new target
			current_offset -= target_offset
			
			
			# Absolute target scale
			
			# Don't use vector lerp
			
			calculate_new_scale()
			
			try_scale()
			
			calculate_new_scale()
	else:
		# Hide all arrows if the box is not focused
		$yArrow.visible = false
		$xArrow.visible = false
	
	parent.collision_mask = 1
	# Apply gravity
	if not parent.is_on_floor():
		parent.velocity += parent.get_gravity() * delta
	parent.move_and_slide()
	
	parent.collision_mask = 3
	
	# Don't distort the sprite, it's in tiling mode anyway
	sprite.global_scale = Vector2.ONE
	calculate_reach_box()
	$BoxOverlay.visible = Input.is_action_pressed("toggle_reach_box")
	#sprite.region_rect.size = sprite_region_size * new_scale
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	# Query mouse position, is the mouse hovering the parent anywhere?
	var state = get_world_2d().direct_space_state
	var point_params = PhysicsPointQueryParameters2D.new()
	point_params.position = get_global_mouse_position()
	
	if not Global.is_scaler_selected(self):
		for x in state.intersect_point(point_params, 1):
			if x.collider == parent:
				Global.select_scaler(self)
				break
	
	# Prevent the arrows from looking very bad
	global_scale = Vector2.ONE
	
func try_scale() -> void:
	# No scaling necessary
	if new_scale == parent.scale:
		return
	
	# check if scaled up or down
	var scale_down = new_scale.x - parent.scale.x < -0.01 or new_scale.y - parent.scale.y < -0.01
	
	# get expansion size (half)
	var expansion = collider_size * new_scale/2 - collider_size*parent.scale/2
	
	if scale_down:
		scale_objects(retraction_direction * collider_size/2 * (parent.scale - new_scale))
		return
	
	# check if expandable to both sides
	if not test_move(expansion * -1) and not test_move(expansion):
		scale_objects(Vector2.ZERO)
		print("expanding both sides")
		return
	
	# check sides respectively with doubled expansion
	if not test_move(expansion * -2):
		scale_objects(expansion * -1)
		print("expanding left")
		print(expansion * -1)
		return
	elif not test_move(expansion * 2):
		scale_objects(expansion)
		print("expanding right")
		return
	
	# no expansion possible
	# Reset the target
	target_offset += current_offset
	return
	
func test_move(motion: Vector2) -> bool:
	return parent.test_move(parent.transform, motion, null, 0, false)
	
func scale_objects(delta_position):
	print()
	scaleTween = create_tween().set_trans(Tween.TRANS_SINE)
	scaleTween.tween_method(_scale_tween_callback.bind(delta_position, parent.scale, parent.position), parent.scale, new_scale, .2)

func _scale_tween_callback(t_scale: Vector2, delta_position: Vector2, start_scale: Vector2, start_position: Vector2):
	parent.scale = t_scale
	if t_scale.x < start_scale.x or t_scale.y < start_scale.y:
		parent.position = start_position + retraction_direction * collider_size/2 * (start_scale - t_scale)
	else:
		parent.position = start_position + delta_position * (t_scale - start_scale)
	sprite.region_rect.size = sprite_region_size * t_scale
	
	
func calculate_reach_box():
	var box: Sprite2D = $BoxOverlay
	box.global_scale = MAX_SCALE
	var dir = Vector2.UP
	dir = retraction_direction * -1
	if get_parent().get_children().any(func(node): return node is WallGlue) or test_move(dir * box.get_rect().size * -1):
		var glues = get_parent().find_children("*", "WallGlue")
		if glues.size() > 0:
			var glue: WallGlue = glues[0]
			var glue_dir = glue.direction.normalized() * -1
			if glue_dir != dir:
				#dir += glue_dir
				pass
		
		var current_box_count = Global.lerp(Vector2.ONE, MAX_SCALE, target_offset) - Vector2.ONE
		var max_box_count = MAX_SCALE - Vector2.ONE
		var distance = dir * (max_box_count - current_box_count) * box.get_rect().size/2
		box.position = distance
		
func _on_box_visible():
	Global.add_scaler(self)
	
func _on_box_invisible():
	Global.remove_scaler(self)
	
func _exit_tree() -> void:
	Global.remove_scaler(self)
	

extends Node2D

var editing := false

@export var MAX_SCALE = Vector2(5.0, 5.0)

@export var target_offset := Vector2.ZERO
var current_offset = target_offset
var new_scale     := Vector2.ONE

@onready var parent: CollisionObject2D = $".."
@onready var line: Line2D = $Line2D
@onready var sprite: Sprite2D = $"../Sprite2D"
@onready var sprite_region_size: Vector2 = sprite.region_rect.size
@onready var collider_size: Vector2 = parent.get_child(0).shape.get_rect().size
@onready var STEP = Vector2.ONE / (MAX_SCALE - Vector2.ONE)

var scaleTween: Tween
var positionTween: Tween
var sprite_recp_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	line.width = 1
	line.default_color = Color.DARK_BLUE
	scaleTween = create_tween()
	positionTween = create_tween()
	sprite_recp_tween = create_tween()
	scaleTween.tween_interval(0.1)
	positionTween.tween_interval(0.1)
	sprite_recp_tween.tween_interval(0.1)
	scaleTween.stop()
	positionTween.stop()
	sprite_recp_tween.stop()
	
	if target_offset != Vector2.ZERO:
		calculate_new_scale()
		try_scale()
	#line.z_index = 5
	#parent.mouse_entered.connect(func(): editing = true)
	#parent.mouse_exited.connect(func(): editing = false)
	#parent.mouse_shape_exited.connect(func(_idx): print("t"))
	#parent.input_event.connect(func(viewport, event, idx): print(event))

func is_tweening():
	return scaleTween.is_running() or positionTween.is_running()

func calculate_new_scale():
	new_scale = Global.lerp(Vector2.ONE, MAX_SCALE, target_offset)

func _physics_process(delta: float) -> void:
	# if mouse is in body
	if editing:
		# What axis are we editing?
		var toggled = Input.is_action_pressed("scale_toggle")
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
					target_offset.y += STEP.y
				elif not toggled and ProgressStore.horizontal_scale_enabled:
					target_offset.x += STEP.x
			elif Input.is_action_just_released("mouse_wheel_down"):
				if toggled and ProgressStore.vertical_scale_enabled:
					target_offset.y -= STEP.y
				elif not toggled and ProgressStore.horizontal_scale_enabled:
					target_offset.x -= STEP.x
			
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
	#sprite.region_rect.size = sprite_region_size * new_scale
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	# Query mouse position, is the mouse hovering the parent anywhere?
	var state = get_world_2d().direct_space_state
	var point_params = PhysicsPointQueryParameters2D.new()
	point_params.position = get_global_mouse_position()
	editing = false
	for x in state.intersect_point(point_params, 1):
		if x.collider == parent:
			editing = true
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
	var expansion = Vector2(collider_size.x * new_scale.x/2 - collider_size.x * parent.scale.x/2, collider_size.y * new_scale.y/2 - collider_size.y * parent.scale.y/2)
	
	if scale_down:
		var motion_down = Vector2(0, collider_size.y * new_scale.y/4 - 0.1)
		motion_down = Vector2.ZERO
		scale_objects(Vector2.ZERO if expansion.x != 0 else motion_down)
		return
	
	# Debug line
	line.clear_points()
	line.add_point(position)
	line.add_point(position + expansion)
	
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
	
func scale_objects(new_position):
	scaleTween = create_tween()
	scaleTween.tween_property(parent, "scale", new_scale, .2)
	positionTween = create_tween()
	positionTween.set_ease(Tween.EASE_OUT).tween_property(parent, "position", parent.position + new_position, .1)
	sprite_recp_tween = create_tween()
	sprite_recp_tween.tween_property(sprite, "region_rect:size", sprite_region_size * new_scale, .2)
	#create_tween().tween_property(region_rect, "size", sprite_region_size * new_scale, 0.2)
	#parent.scale = new_scale
	
func calculate_reach_box():
	var box: Sprite2D = $BoxOverlay
	box.global_scale = MAX_SCALE
	var dir = Vector2.UP
	if get_parent().get_children().any(func(node): return node is WallGlue) or test_move(dir * box.get_rect().size * -1):
		var glues = get_parent().find_children("*", "WallGlue")
		if glues.size() > 0:
			var glue: WallGlue = glues[0]
			var glue_dir = glue.direction.normalized() * -1
			if glue_dir != dir:
				dir += glue_dir
		
		var current_box_count = Global.lerp(Vector2.ONE, MAX_SCALE, target_offset) - Vector2.ONE
		var max_box_count = MAX_SCALE - Vector2.ONE
		var distance = dir * (max_box_count - current_box_count) * box.get_rect().size/2
		box.position = distance
	

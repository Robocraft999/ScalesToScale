extends Node2D

var editing := false

@export var STEP = 0.25
@export var MAX_SCALE = 5

var offset := Vector2.ZERO
var offset_offset = offset
var new_scale := Vector2.ONE

@onready var parent: CollisionObject2D = $".."
@onready var line: Line2D = $Line2D
@onready var sprite: Sprite2D = $"../Sprite2D"
@onready var sprite_region_size: Vector2 = sprite.region_rect.size
@onready var collider_size: Vector2 = parent.get_child(0).shape.get_rect().size

var scaleTween: Tween
var positionTween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	line.width = 1
	line.default_color = Color.DARK_BLUE
	scaleTween = create_tween()
	positionTween = create_tween()
	#line.z_index = 5
	#parent.mouse_entered.connect(func(): editing = true)
	#parent.mouse_exited.connect(func(): editing = false)
	#parent.mouse_shape_exited.connect(func(_idx): print("t"))
	#parent.input_event.connect(func(viewport, event, idx): print(event))

func _physics_process(delta: float) -> void:
	if editing:
		var toggled = Input.is_action_pressed("scale_toggle")
		if toggled:
			$yArrow.visible = true
			$xArrow.visible = false
		else:
			$yArrow.visible = false
			$xArrow.visible = true
		
		offset_offset = offset
		if Input.is_action_just_released("mouse_wheel_up"):
			if toggled:
				offset.y += STEP
			else:
				offset.x += STEP
		elif Input.is_action_just_released("mouse_wheel_down"):
			if toggled:
				offset.y -= STEP
			else:
				offset.x -= STEP
		
		offset.x = clamp(offset.x, 0, 1)
		offset.y = clamp(offset.y, 0, 1)
		offset_offset -= offset
	else:
		$yArrow.visible = false
		$xArrow.visible = false
		
	
	new_scale = Vector2(lerp(1, MAX_SCALE, offset.x), lerp(1, MAX_SCALE, offset.y))
	
	if not parent.is_on_floor():
		parent.velocity += parent.get_gravity() * delta
	parent.move_and_slide()
	
	#if not positionTween.is_running() and not scaleTween.is_running():
	var motion = try_scale()
	if motion != Vector2.ZERO:
		pass
		#parent.move_and_collide(motion)
	sprite.global_scale = Vector2.ONE
	sprite.region_rect.size = sprite_region_size * new_scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var state = get_world_2d().direct_space_state
	var point_params = PhysicsPointQueryParameters2D.new()
	point_params.position = get_global_mouse_position()
	editing = false
	
	for x in state.intersect_point(point_params, 1):
		if x.collider == parent:
			editing = true
			break
			
	global_scale = Vector2.ONE
	
func try_scale() -> Vector2:
	if new_scale == parent.scale:
		return Vector2.ZERO
	
	# check if scaled up or down
	var scale_down = new_scale.x - parent.scale.x < -0.01 or new_scale.y - parent.scale.y < -0.01
	
	if scale_down:
		scale_objects(Vector2.ZERO)
		var motion_down = Vector2(0, collider_size.y * new_scale.y/2 - 0.1)
		if not test_move(motion_down):
			return motion_down
		return Vector2.ZERO
		
	# get expansion size (half)
	var expansion = Vector2(collider_size.x * new_scale.x/2 - collider_size.x * parent.scale.x/2, collider_size.y * new_scale.y/2 - collider_size.y * parent.scale.y/2)
	line.clear_points()
	line.add_point(position)
	line.add_point(position + expansion)
	
	if not positionTween.is_running() and not scaleTween.is_running():
		return Vector2.ZERO
	
	# check if can expand to both sides
	if not test_move(expansion * -1) and not test_move(expansion):
		scale_objects(Vector2.ZERO)
		print("expanding both sides")
		return Vector2.ZERO
	
	# check sides respectively with doubled expansion
	if not test_move(expansion * -2):
		scale_objects(expansion * -1)
		print("expanding left")
		print(expansion * -1)
		return expansion * -1
	elif not test_move(expansion * 2):
		scale_objects(expansion)
		print("expanding right")
		return expansion
	
	# no expansion possible
	offset += offset_offset
	return Vector2.ZERO
	
func test_move(motion: Vector2) -> bool:
	return parent.test_move(parent.transform, motion, null, 0, false)
	
func scale_objects(new_position):
	scaleTween = create_tween()
	scaleTween.tween_property(parent, "scale", new_scale, 0.2)
	positionTween = create_tween()
	positionTween.set_trans(Tween.TRANS_LINEAR).tween_property(parent, "position", parent.position + new_position, 0.1)
	#create_tween().tween_property(region_rect, "size", sprite_region_size * new_scale, 0.2)
	#parent.scale = new_scale
	

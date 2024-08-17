extends Node2D

var editing := false

const STEP = 0.25
const MAX_SCALE = 5

var offset := Vector2.ZERO
var new_scale := Vector2.ONE

@onready var parent: CollisionObject2D = $".."
@onready var line: Line2D = $Line2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	line.width = 1
	line.default_color = Color.DARK_BLUE
	#line.z_index = 5
	#parent.mouse_entered.connect(func(): editing = true)
	#parent.mouse_exited.connect(func(): editing = false)
	#parent.mouse_shape_exited.connect(func(_idx): print("t"))
	#parent.input_event.connect(func(viewport, event, idx): print(event))

func _physics_process(delta: float) -> void:
	if not parent.is_on_floor():
		parent.velocity += parent.get_gravity() * delta
	parent.move_and_slide()
	
	var collider_size = parent.get_child(0).shape.get_rect().size
	var motion = try_scale(collider_size)
	if motion != Vector2.ZERO:
		parent.move_and_collide(motion)

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
			
	#if Input.is_action_just_pressed("dash"):
		#print(offset)
	
	if editing:
		var toggled = Input.is_action_pressed("scale_toggle")
		if toggled:
			$yArrow.visible = true
			$xArrow.visible = false
		else:
			$yArrow.visible = false
			$xArrow.visible = true
		
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
	else:
		$yArrow.visible = false
		$xArrow.visible = false
		
	new_scale = Vector2(lerp(1, MAX_SCALE, offset.x), lerp(1, MAX_SCALE, offset.y))
	global_scale = Vector2.ONE
	
func try_scale(collider_size: Vector2) -> Vector2:
	if new_scale == parent.scale:
		return Vector2.ZERO
	
	# check if scaled up or down
	var scale_down = new_scale.x < parent.scale.x or new_scale.y < parent.scale.y
	
	if scale_down:
		parent.scale = new_scale
		print("downscale")
		return Vector2.ZERO
	
	# get expansion size (half)
	var expansion = Vector2(collider_size.x * new_scale.x/2 - collider_size.x * parent.scale.x/2, collider_size.y * new_scale.y/2 - collider_size.y * parent.scale.y/2)
	line.clear_points()
	line.add_point(position)
	line.add_point(position + expansion)
	
	# check if can expand to both sides
	if not test_move(expansion * -1) and not test_move(expansion):
		parent.scale = new_scale
		print("expanding both sides")
		return Vector2.ZERO
	
	# check sides respectively with doubled expansion
	if not test_move(expansion * -2):
		parent.scale = new_scale
		print("expanding left")
		return expansion * -1
	elif not test_move(expansion * 2):
		parent.scale = new_scale
		print("expanding right")
		return expansion
	
	# no expansion possible
	
	return Vector2.ZERO
	
func test_move(motion: Vector2) -> bool:
	return parent.test_move(parent.transform, motion, null, 0, true)

extends Node2D

var editing := false

const STEP = 0.25
const MAX_SCALE = 3

var offset := Vector2.ZERO

@onready var parent: CollisionObject2D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#parent.mouse_entered.connect(func(): editing = true)
	#parent.mouse_exited.connect(func(): editing = false)
	#parent.mouse_shape_exited.connect(func(_idx): print("t"))
	#parent.input_event.connect(func(viewport, event, idx): print(event))

func _physics_process(delta: float) -> void:
	if not parent.is_on_floor():
		parent.velocity += parent.get_gravity() * delta
	parent.move_and_slide()

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
		
	

	parent.scale.x = lerp(1, MAX_SCALE, offset.x)
	parent.scale.y = lerp(1, MAX_SCALE, offset.y)
	global_scale = Vector2.ONE

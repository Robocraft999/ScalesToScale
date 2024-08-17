extends CharacterBody2D
class_name Player

@export_category("Speed, Velocity, Physics")
@export var SPEED = 100.0
@export var JUMP_VELOCITY = -250.0
@export var DOUBLE_JUMP_VELOCITY = -250.0

@export_category("Jump timings")
# How long the jump will be buffered
@export var JUMP_BUFFER_TIMEOUT_MILLIS := 250
# How long the coyote jump grace timing is
@export var JUMP_COYOTE_TIMEOUT_MILLIS := 250
@export_category("Dash")
# How long a dash will last
@export var DASH_DURATION_MILLIS := 250
@export var DASH_REFRESH_MILLIS  := 1500
# Distance traveled in total
@export var DASH_VELOCITY        := 300

# msec ticks at which the jump was last buffered
var jump_buffer_time  := 0
# msec ticks at wich the player was last on the floor
var jump_coyote_time  := 0
var jump_double_ready := true

# msec ticks when the dash was last started
var dash_start_time   := 0
var active_dash_direction := Vector2.ZERO

func is_dash_ready():
	return Time.get_ticks_msec() - dash_start_time > DASH_REFRESH_MILLIS

func is_dash_active():
	return Time.get_ticks_msec() - dash_start_time <= DASH_DURATION_MILLIS

func get_actual_gravity() -> Vector2:
	if velocity.y < 0:
		return get_gravity()
	return get_gravity() * 1.5

func _physics_jump() -> void:
	if is_on_floor():
			# Reset the coyote timer
		jump_coyote_time = Time.get_ticks_msec()
		# Make double jump available again
		jump_double_ready = true

	# Handle jump types.
	var regular_jump  = Input.is_action_just_pressed("jump") \
						and is_on_floor()
	var buffered_jump = Time.get_ticks_msec() - jump_buffer_time < JUMP_BUFFER_TIMEOUT_MILLIS \
						and is_on_floor()
	var coyote_jump   = Input.is_action_just_pressed("jump") \
						and Time.get_ticks_msec() - jump_coyote_time < JUMP_COYOTE_TIMEOUT_MILLIS \
						and not is_on_floor()
	if regular_jump or buffered_jump or coyote_jump:
		velocity.y = JUMP_VELOCITY
		jump_buffer_time = 0
		jump_coyote_time = 0
	elif Input.is_action_just_pressed("jump") and jump_double_ready and not is_on_floor():
		velocity.y = DOUBLE_JUMP_VELOCITY
		jump_double_ready = false
	elif Input.is_action_just_pressed("jump") and not is_on_floor():
		jump_buffer_time = Time.get_ticks_msec()
	
	pass

func _physics_dash() -> void:
	if is_dash_ready() and Input.is_action_just_pressed("dash"):
		dash_start_time = Time.get_ticks_msec()
		var direction_x = Input.get_axis("move_left", "move_right")
		# TODO: Dash downwards
		var direction_y = -1 if Input.is_action_pressed("jump") else 0
		
		active_dash_direction = Vector2(direction_x, direction_y).normalized()
		pass
	
	if is_dash_active():
		velocity += active_dash_direction * DASH_VELOCITY
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_actual_gravity() * delta
	
	_physics_jump()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	_physics_dash()

	move_and_slide()

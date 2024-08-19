extends CharacterBody2D
class_name Player

signal dash_started
signal jumped
signal double_jumped
signal landed_on_floor(impact_velocity: Vector2)


@export var allow_movement := true

@export_category("Speed, Velocity, Physics")
@export var SPEED = 150.0
@export var JUMP_VELOCITY = -350.0
@export var DOUBLE_JUMP_VELOCITY = -350.0

@export_category("Jump timings")
# How long the jump will be bufferedda
@export var JUMP_BUFFER_TIMEOUT_MILLIS := 250
# How long the coyote jump grace timing is
@export var JUMP_COYOTE_TIMEOUT_MILLIS := 125
@export_category("Dash")
# How long a dash will last
@export var DASH_DURATION_MILLIS  := 250
@export var DASH_REFRESH_MILLIS   := 1500
# Distance traveled in total
@export var DASH_VELOCITY           := Vector2(300.0, 300.0)
@export var GHOST_DURATION_MILLIS   := 200
@export var GHOST_SPAWN_PERCENTAGES: Array[int] = [5, 10, 15, 30, 50, 70, 80, 85, 95]

# msec ticks at which the jump was last buffered
var jump_buffer_time  := 0
# msec ticks at wich the player was last on the floor
var jump_coyote_time  := 0
var jump_double_ready := true

# msec ticks when the dash was last started
var dash_start_time   := 0
var active_dash_direction := Vector2.ZERO
var dash_next_ghost_percentage_index = 0

# For landing detection
var was_on_floor := true
var last_velocity := Vector2.ZERO

# for the sprite
# 1 : left
# -1: right
var looking_direction := 1.0

func dash_time_since_started() -> int:
	return Time.get_ticks_msec() - dash_start_time

func dash_active_time_remaining() -> int:
	return DASH_DURATION_MILLIS - dash_time_since_started() if is_dash_active() else 0

func dash_timeout_remaining() -> int:
	return 0 if is_dash_ready() else DASH_REFRESH_MILLIS - dash_time_since_started()

func is_dash_ready() -> bool:
	return Time.get_ticks_msec() - dash_start_time > DASH_REFRESH_MILLIS

func is_dash_active() -> bool:
	return Time.get_ticks_msec() - dash_start_time < DASH_DURATION_MILLIS

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
		# Jump now
		velocity.y = JUMP_VELOCITY
		jump_buffer_time = 0
		jump_coyote_time = 0
		jumped.emit()
	elif Input.is_action_just_pressed("jump") and jump_double_ready and not is_on_floor() and ProgressStore.double_jump_enabled:
		# Double Jump
		velocity.y = DOUBLE_JUMP_VELOCITY
		jump_double_ready = false
		double_jumped.emit()
	elif Input.is_action_just_pressed("jump") and not is_on_floor():
		# Buffer the jump action
		jump_buffer_time = Time.get_ticks_msec()
	
	pass

func dash_trail_effect() -> void:
	
	# Is it time to spawn another ghost image?
	var time_passed = float(dash_time_since_started())
	var percentage_passed = int(100 * time_passed / float(DASH_DURATION_MILLIS))
	var target_percentage = GHOST_SPAWN_PERCENTAGES[dash_next_ghost_percentage_index]
	
	
	if target_percentage < percentage_passed:
		# Next percentage index
		dash_next_ghost_percentage_index += 1
		
		# Create a copy of the players sprite
		var ghost_image: AnimatedSprite2D = $AnimatedSprite2D.duplicate()
		ghost_image.scale = $AnimatedSprite2D.global_scale
		if self.looking_direction == -1.0:
			ghost_image.scale *= -1
		
		# Tween the alpha to make the ghost image slowly disappear
		# Also free the image when it's completely transparent
		var alpha_tween = ghost_image.create_tween()
		var duration = float(GHOST_DURATION_MILLIS) / 1000.0
		alpha_tween.tween_property(ghost_image, "modulate", Color.TRANSPARENT, duration)
		alpha_tween.tween_callback(ghost_image.queue_free)
		
		# Add to parent scene
		get_parent().add_child(ghost_image)
		
		# Copy player position
		ghost_image.position = $AnimatedSprite2D.global_position
		
		pass
	pass

func _physics_dash() -> void:
	if is_dash_ready() and Input.is_action_pressed("dash"):
		var direction_x = Input.get_axis("move_left", "move_right")
		# TODO: Dash downwards
		var direction_y = -1 if Input.is_action_pressed("jump") else 0
		
		active_dash_direction = Vector2(direction_x, direction_y).normalized()
		
		if active_dash_direction != Vector2.ZERO:
			# DASH
			dash_start_time = Time.get_ticks_msec()
			velocity.y = active_dash_direction.y * DASH_VELOCITY.y
			$AudioStreamPlayer2D.play(0.30)
			dash_next_ghost_percentage_index = 0
			dash_started.emit()
		pass
	
	if is_dash_active():
		velocity.x += active_dash_direction.x * DASH_VELOCITY.x
		dash_trail_effect()
		pass
	pass

func update_direction():
	var new_looking_direction = 0.0
	if self.velocity.x < 0:
		new_looking_direction = 1.0
	if self.velocity.x > 0:
		new_looking_direction = -1.0
	if new_looking_direction != 0.0 and new_looking_direction != looking_direction:
		self.scale.x *= -1 # flip it
		looking_direction = new_looking_direction
		pass
	pass

func update_animations():
	if velocity.x == 0.0:
		# TODO: Proper walking state
		$AnimatedSprite2D.pause()
	if not $AnimatedSprite2D.is_playing() and velocity.x != 0.0:
		$AnimatedSprite2D.play()

func _physics_process(delta: float) -> void:
	
	if not allow_movement:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_actual_gravity() * delta

	if ProgressStore.jump_enabled:
		_physics_jump()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if ProgressStore.dash_enabled:
		_physics_dash()

	move_and_slide()
	
	update_direction()
	
	update_animations()
	
	# Emit signals
	if not was_on_floor and is_on_floor():
		landed_on_floor.emit(last_velocity)
	
	# Set the 'past iteration' variables
	last_velocity = self.velocity
	was_on_floor = is_on_floor()
	pass

extends CharacterBody2D
class_name Player

const SPEED = 100.0
const JUMP_VELOCITY = -250.0

@export var JUMP_BUFFER_TIMEOUT_MILLIS := 250

var jump_buffer_time := 0

func get_actual_gravity() -> Vector2:
	if velocity.y < 0:
		return get_gravity()
	return get_gravity() * 1.5

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_actual_gravity() * delta

	# Handle jump.
	if (Input.is_action_just_pressed("jump") or Time.get_ticks_msec() - jump_buffer_time < JUMP_BUFFER_TIMEOUT_MILLIS) and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_buffer_time = 0
	elif Input.is_action_just_pressed("jump") and not is_on_floor():
		jump_buffer_time = Time.get_ticks_msec()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

extends Node2D

var editing := false

const STEP = 0.25
const MAX_SCALE = 3

var offset := Vector2.ZERO

@onready var parent: CollisionObject2D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent.mouse_entered.connect(func(): editing = true)
	parent.mouse_exited.connect(func(): editing = false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var toggled = Input.is_action_pressed("scale_toggle")
	if editing:
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

	parent.scale.x = lerp(1, MAX_SCALE, offset.x)
	parent.scale.y = lerp(1, MAX_SCALE, offset.y)
	global_scale = Vector2.ONE

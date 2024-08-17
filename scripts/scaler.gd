extends Node2D

var draggingX := false
var draggingY := false

const MAX_OFFSET = 15
const MIN_OFFSET = 10

const MAX_SCALE = 2

var scaler_offset := Vector2(MIN_OFFSET,MIN_OFFSET)
var item_offset := scaler_offset

@onready var xRect = $xRect
@onready var yRect = $yRect
@onready var item: StaticBody2D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	xRect.mouse_entered.connect(func(): draggingX = true)
	yRect.mouse_entered.connect(func(): draggingY = true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if draggingX:
		if Input.is_action_pressed("mouse_left"):
			var requested_offset = get_global_mouse_position() - global_position
			scaler_offset.x = clamp(requested_offset.x, MIN_OFFSET, MAX_OFFSET)
			item_offset.x = scaler_offset.x
		else:
			draggingX = false
	else:
		scaler_offset.x = MIN_OFFSET
		
	if draggingY:
		if Input.is_action_pressed("mouse_left"):
			var requested_offset = get_global_mouse_position() - global_position
			scaler_offset.y = clamp(requested_offset.y, MIN_OFFSET, MAX_OFFSET)
			item_offset.y = scaler_offset.y
		else:
			draggingY = false
	else:
		scaler_offset.y = MIN_OFFSET
	
	xRect.position.x = scaler_offset.x
	$xLine.points[1].x = scaler_offset.x
	yRect.position.y = scaler_offset.y
	$yLine.points[1].y = scaler_offset.y
	item.scale.x = lerp(1, MAX_SCALE, (item_offset.x-MIN_OFFSET) / (MAX_OFFSET-MIN_OFFSET))
	item.scale.y = lerp(1, MAX_SCALE, (item_offset.y-MIN_OFFSET) / (MAX_OFFSET-MIN_OFFSET))
	global_scale = Vector2.ONE

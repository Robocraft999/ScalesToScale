extends Node2D
class_name Shaker

@export_range(0.0, 50.0, 1, "or_greater")    var shake_decay_rate := 1.0
@export_range(1.0, 50.0, 1, "or_greater")    var shake_roughness  := 50
@export var shake_strength           := Vector2.ZERO
@export var shake_x                  := true
@export var shake_y                  := true
@export var target: NodePath          = ".."
@export var property_name: StringName = &"position"

@onready var noise = FastNoiseLite.new()

var noise_index := 0
var last_offset := Vector2.ZERO

func get_shake():
	noise_index += shake_roughness
	
	return Vector2(
		noise.get_noise_2d(0., noise_index) if shake_x else 0.0,
		noise.get_noise_2d(100.0, noise_index) if shake_y else 0.0
	)

func apply_property_diff(difference: Vector2):
	var target_node = get_node(target)
	var old_value   = target_node.get(property_name)
	var new_value   = old_value + difference
	target_node.set(property_name, new_value)
	pass

func _process(delta: float) -> void:
	if Global.enable_screen_shake:
		shake_strength = lerp(shake_strength, Vector2.ZERO, shake_decay_rate * delta)

		apply_property_diff(-last_offset)
		last_offset = get_shake() * shake_strength
		apply_property_diff(last_offset)
	else:
		if last_offset != Vector2.ZERO:
			apply_property_diff(-last_offset)
			last_offset = Vector2.ZERO
			pass
		pass
	pass

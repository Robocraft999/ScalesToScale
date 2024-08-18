extends Node
class_name ShakerAnimator

@onready var player = %Player
@onready var camera_shaker = %CameraShaker

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.landed_on_floor.connect(_on_player_landed_on_floor)

func _on_player_landed_on_floor(impact_velocity: Vector2) -> void:
	var squashed_speed = atan(impact_velocity.y / 100) * 5
	camera_shaker.shake_strength = Vector2(0.0, squashed_speed)
	camera_shaker.shake_roughness = 15.0
	camera_shaker.shake_decay_rate = 5.0

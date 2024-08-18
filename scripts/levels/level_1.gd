extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$DragonFlag.body_entered.connect(_on_dragon_flag_body_entered)

func start_animation_finished() -> void:
	%CameraShaker.shake_strength = 15.0
	%CameraShaker.shake_x = false
	%CameraShaker.shake_decay_rate = 5.0

func _on_dragon_flag_body_entered(body: Node2D) -> void:
	if body is Player:
		var cam: BetterCamera2D = $Camera2D
		cam.follow_node = $DragonFlag
		cam.dead_zone = Vector2.ZERO
		var tween = create_tween()
		tween.tween_property(cam, "zoom", Vector2(3,3), 3)
		tween.chain().tween_property(body, "position", Vector2(body.position.x, 0), 3)
		tween.finished.connect(func(): OptionsManager.get_scene_manager())
		body.allow_movement = false
		pass
	pass

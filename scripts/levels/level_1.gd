extends Node2D

func start_animation_finished() -> void:
	%CameraShaker.shake_strength = Vector2(0, 15.0)
	%CameraShaker.shake_decay_rate = 1.0
	await get_tree().create_timer(0.5).timeout
	%CameraShaker.shake_strength = Vector2.ZERO

func handle(_body: Player):
	ProgressStore.horizontal_scale_enabled = true
	$ScaleExplanation.visible = true

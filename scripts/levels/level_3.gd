extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TypewriterTrigger.body_entered.connect(_trigger_animation)

func _trigger_animation(body: Node2D):
	if body is Player:
		$EditableLevel/Camera2D.follow_node = $EditableLevel/ExampleBox
		$TypewriterAnimationPlayer.play("typewriter_animation")
		$TypewriterTrigger.body_entered.disconnect(_trigger_animation)
		await $TypewriterAnimationPlayer.animation_finished
		$EditableLevel/Camera2D.follow_node = %Player
	pass

func start_animation_finished() -> void:
	%CameraShaker.shake_strength = Vector2(0, 15.0)
	%CameraShaker.shake_decay_rate = 1.0
	await get_tree().create_timer(0.5).timeout
	%CameraShaker.shake_strength = Vector2.ZERO

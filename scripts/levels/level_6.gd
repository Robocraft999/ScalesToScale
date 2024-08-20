extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProgressStore.jump_enabled = true
	ProgressStore.double_jump_enabled = true
	ProgressStore.dash_enabled = true
	ProgressStore.horizontal_scale_enabled = true
	ProgressStore.vertical_scale_enabled = true
	ProgressStore.time_scale_enabled = true
	%Player.get_node("AnimatedSprite2D").play("fly")
	$Checkpoints/Checkpoint2.connect("checkpoint_saved", _fire_platform1)
	$Checkpoints/Checkpoint3.checkpoint_saved.connect(_fire_double_spikes)
	$Checkpoints/Checkpoint4.checkpoint_saved.connect(_start_final_animation)

func _start_final_animation():
	$MovingPlatform/EndPlatformMover.go()

func _fire_double_spikes():
	$MovingSpikes/Mover3.go()
	$MovingSpikes/Mover4.go()
	$MovingSpikes/Mover5.go()
	$Checkpoints/Checkpoint3.checkpoint_saved.disconnect(_fire_double_spikes)

func _fire_platform1():
	$MovingPlatform/DangerMover.go()

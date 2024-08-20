extends Node2D

signal checkpoint_saved

## greater values are later checkpoints
@export var id := 0
var checked := false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if Global.checkpoint_id <= id:
			if not checked:
				$GPUParticles2D.emitting = true
			checked = true
			Global.checkpoint_position = global_position + Vector2(0, - body.get_child(0).shape.get_rect().size.y/2 - 5)
			Global.checkpoint_id = id
			checkpoint_saved.emit()

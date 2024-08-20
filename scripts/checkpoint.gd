extends Node2D

## greater values are later checkpoints
@export var id := 0


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if Global.checkpoint_id <= id:
			Global.checkpoint_position = global_position + Vector2(0, - body.get_child(0).shape.get_rect().size.y/2 - 5)
			Global.checkpoint_id = id
			

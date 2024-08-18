extends Node
class_name WallGlue


@export var direction: Vector2 = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var parent = get_parent()
	if not parent.test_move(parent.transform, direction):
		parent.position += direction
		pass
	pass

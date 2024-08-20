extends Node
class_name WallGlue


@export var direction: Vector2 = Vector2.ZERO
var parent

func _ready() -> void:
	get_tree().create_timer(0.1).timeout.connect(func(): parent = get_parent())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	#var parent = get_parent()
	if not parent:
		return
	
	parent.collision_mask = 1
	if not parent.test_move(parent.transform, direction):
		parent.position += direction
		pass
	pass
	parent.collision_mask = 3

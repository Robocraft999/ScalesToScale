extends Area2D
class_name Collectible

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_entered(node: Node2D):
	#print(node)
	if node is Player:
		queue_free()
	pass

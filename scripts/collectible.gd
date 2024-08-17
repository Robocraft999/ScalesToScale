extends Area2D
class_name Collectible

@export var type: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_area_entered)

func _on_area_entered(node: Node2D):
	#print(node)
	if node is Player:
		handle(node)
		queue_free()
	pass
	
func handle(player: Player):
	if type:
		type.handle(player)

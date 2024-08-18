extends Area2D

signal player_entered(body: Area2D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	pass

func _on_body_entered(body: Node2D):
	if body is Player:
		player_entered.emit(body)
		pass
	pass

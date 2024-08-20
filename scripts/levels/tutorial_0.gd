extends Node2D

func _ready() -> void:
	ProgressStore.disable_all()
	pass

# Collectible pickup
func handle(_player: Player):
	ProgressStore.jump_enabled = true
	$UpKeyCap.visible = true

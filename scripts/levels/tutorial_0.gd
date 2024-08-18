extends Node2D

func _ready() -> void:
	$UpKeyCap.visible = ProgressStore.jump_enabled
	pass

# Collectible pickup
func handle(_player: Player):
	ProgressStore.jump_enabled = true
	$UpKeyCap.visible = true
	pass

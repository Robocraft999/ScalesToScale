extends Node2D

func _ready() -> void:
	ProgressStore.disable_all()
	pass

# Collectible pickup
func handle(_player: Player):
	ProgressStore.jump_enabled = true
	$UpKeyCap.visible = true
	create_tween().tween_property($NameLabel, "visible_ratio", 1.0, 3.0)

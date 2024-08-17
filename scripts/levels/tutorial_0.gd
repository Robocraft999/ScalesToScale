extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$UpKeyCap.visible = ProgressStore.jump_enabled

# Collectible pickup
func handle(player: Player):
	ProgressStore.jump_enabled = true

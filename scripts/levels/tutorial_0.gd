extends Node2D

func _ready() -> void:
	$UpKeyCap.visible = ProgressStore.jump_enabled
	pass

# Collectible pickup
func handle(_player: Player):
	ProgressStore.jump_enabled = true
	$UpKeyCap.visible = true


func _on_dragon_flag_body_entered(body: Node2D) -> void:
	if body is Player:
		var cam: BetterCamera2D = $Camera2D
		cam.follow_node = $DragonFlag
		cam.dead_zone = Vector2.ZERO
		var tween = create_tween()
		tween.tween_property(cam, "zoom", Vector2(3,3), 3)
		tween.chain().tween_property(body, "position", Vector2(body.position.x, 0), 3)
		tween.finished.connect(func(): SceneLoader.load_level_scene_by_name("MainMenu"))
		await get_tree().create_timer(0.5).timeout
		body.allow_movement = false
		pass
	pass

extends Node2D

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$UpKeyCap.visible = ProgressStore.jump_enabled

# Collectible pickup
func handle(player: Player):
	ProgressStore.jump_enabled = true


func _on_dragon_flag_body_entered(body: Node2D) -> void:
	if body is Player:
		var cam: PhantomCamera2D = $PhantomCamera2D
		cam.follow_target = $DragonFlag
		var tween = create_tween()
		tween.tween_property(cam, "zoom", Vector2(3,3), 3)
		tween.chain().tween_property(body, "position", Vector2(body.position.x, 0), 3)
		tween.finished.connect(func(): OptionsManager.get_scene_manager().load_level_scene_by_index(0))
		
		

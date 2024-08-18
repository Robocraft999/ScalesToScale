extends Node
class_name EndAnimator

@onready var flag = $"../DragonFlag"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flag.player_entered.connect(on_flag_player_touched)

func on_flag_player_touched(player: Node2D) -> void:
	var cam: BetterCamera2D = $"../Camera2D"
	cam.follow_node = flag
	cam.dead_zone = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(cam, "zoom", Vector2(2, 2), 2)
	tween.chain().tween_property(player, "position", Vector2(player.position.x, 0), 3)
	tween.finished.connect(func(): SceneLoader.load_level_scene_by_name("MainMenu"))
	await get_tree().create_timer(0.5).timeout
	player.allow_movement = false
	pass

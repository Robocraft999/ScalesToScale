extends Node
class_name EndAnimator

@onready var flag = %DragonFlag
@export_enum(
	Global.SceneName.MAIN_MENU, 
	Global.SceneName.TUTORIAL, 
	Global.SceneName.LEVEL1, 
	Global.SceneName.LEVEL2,
	Global.SceneName.LEVEL3,
	Global.SceneName.LEVEL4,
	Global.SceneName.LEVEL5,
	Global.SceneName.LEVEL6
	) var next_level_name: String = Global.SceneName.MAIN_MENU

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flag.player_entered.connect(on_flag_player_touched)

func on_flag_player_touched(body: Node2D) -> void:
	var player: Player = body
	var cam: BetterCamera2D = $"../Camera2D"
	cam.follow_node = flag
	cam.dead_zone = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(cam, "zoom", Vector2(2, 2), 2)
	tween.chain().tween_property(player, "position", Vector2(player.position.x, flag.position.y - 300), 3)
	tween.finished.connect(func(): SceneLoader.load_level_scene_by_name(next_level_name))
	await get_tree().create_timer(0.5).timeout
	player.allow_movement = false
	player.get_node("AnimatedSprite2D").play("fly")
	pass

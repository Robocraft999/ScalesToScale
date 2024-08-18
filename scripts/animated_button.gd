extends Button
class_name AnimatedButton

var growTween: Tween
var shrinkTween: Tween

@onready var focus_player = %ButtonFocusPlayer

func _ready() -> void:
	focus_entered.connect(_on_focus_entered.bind(false))
	mouse_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	mouse_exited.connect(_on_focus_exited)

func _process(_delta: float) -> void:
	pivot_offset = size / 2

func _on_focus_entered(play_sound: bool = true) -> void:
	if shrinkTween != null and shrinkTween.is_running():
		shrinkTween.stop()

	growTween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_BOUNCE)
	growTween.tween_property(self, "scale", Vector2(1.02, 1.02), 0.5)
	if play_sound:
		focus_player.play()
	pass


func _on_focus_exited() -> void:
	if growTween != null and growTween.is_running():
		growTween.stop()

	shrinkTween = create_tween().bind_node(self).set_trans(Tween.TRANS_BOUNCE)
	shrinkTween.tween_property(self, "scale", Vector2(1., 1.), 0.15)
	pass

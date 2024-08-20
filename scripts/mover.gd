extends Path2D

@onready var _follow: PathFollow2D = $PathFollow2D
@export var target_node: Node2D
@export var SPEED := 5.0
@export_category("Tweening")
@export var trans := Tween.TRANS_SINE
@export var ease_mode := Tween.EASE_IN_OUT
@export var autostart := true
@export var loop := true

func _ready():
	_follow.progress_ratio = 0
	var remote: RemoteTransform2D = $PathFollow2D/RemoteTransform2D
	remote.remote_path = target_node.get_path()
	if autostart:
		go()

func go():
	var tween = create_tween().set_trans(trans).set_ease(ease_mode)
	var propertytween = tween.tween_property(_follow, 'progress_ratio', 1, SPEED / Global.time_scale)
	if loop:
		propertytween.finished.connect(go_back)

func go_back():
	var tween = create_tween().set_trans(trans).set_ease(ease_mode)
	var propertytween = tween.tween_property(_follow, "progress_ratio", 0, SPEED / Global.time_scale)
	if loop:
		propertytween.finished.connect(go)

extends Sprite2D
class_name AnimatedKeyCap

@export var watched_action_name: StringName = ""

var is_active := false

func _procedwadasdss(_delta: float) -> void:
	if Input.is_action_pressed(watched_action_name) and not is_active:
		var growth_tween = create_tween().bind_node(self)
		growth_tween.tween_property(self, "scale", Vector2(1.07, 1.07), 0.2)
		is_active = true
		pass
	
	if not Input.is_action_pressed(watched_action_name) and is_active:
		var shrink_tween = create_tween().bind_node(self)
		shrink_tween.tween_property(self, "scale", Vector2(1., 1.), 0.2)
		is_active = false
		pass
	pass

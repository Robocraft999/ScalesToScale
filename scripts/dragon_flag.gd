extends Area2D

signal player_entered(body: Area2D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	pass

func _on_body_entered(body: Node2D):
	if body is Player:
		player_entered.emit(body)
		$GodRays.visible = true
		$CanvasLayer.visible = true
		var darken_shader: ShaderMaterial = $CanvasLayer/DarkenShader.material
		create_tween().tween_method(func(alpha): darken_shader.set_shader_parameter("alpha", alpha), 0.0, 0.4, 2)
		var god_rays_shader: ShaderMaterial = $GodRays.material
		create_tween().set_trans(Tween.TRANS_SINE).tween_method(func(cutoff): god_rays_shader.set_shader_parameter("cutoff", cutoff), 1.0, 0.0, 1)
		pass
	pass
	

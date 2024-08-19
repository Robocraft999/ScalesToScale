extends CanvasLayer

var running = false
var progress = 0
var SPEED = 3
var current_speed = SPEED

signal half_done

func _process(delta: float) -> void:
	if running:
		progress += delta * current_speed
		var material: ShaderMaterial = $ColorRect.material
		material.set_shader_parameter("Dings", progress)
	
	if progress > 3:
		current_speed *= -1
		half_done.emit()
	
	if progress < 0:
		running = false
		visible = false
		
func start():
	if not running:
		running = true
		progress = 0
		current_speed = SPEED
		visible = true

extends ParallaxLayer

@export var cloud_speed : float = -15

func _process(delta  : float) -> void:
	self.motion_offset.x += cloud_speed * delta

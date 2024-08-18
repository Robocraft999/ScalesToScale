extends Camera2D
class_name BetterCamera2D


@export_enum("Follow", "Point") var mode: String = "Follow"
@export_category("Follow")
@export var follow_node: Node2D
@export var dead_zone: Vector2 = Vector2(0.1, 0.1)
@export_category("Point")
@export var point: Vector2 = Vector2.ZERO

@onready var screen_size = get_viewport().get_visible_rect().size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if mode == "Follow":
		var distance = self.position - follow_node.position
		var screen_distance = abs(distance / screen_size)
		if screen_distance.x > dead_zone.x:
			self.position.x = lerp(self.position.x, follow_node.position.x, screen_distance.x)
		
		if screen_distance.y > dead_zone.y:
			self.position.y = lerp(self.position.y, follow_node.position.y, screen_distance.y)
		pass
	elif mode == "Point":
		self.position = point
		pass
	pass

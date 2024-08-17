extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = "Dash ready: %s, player velocity: %s" % [str($Player.is_dash_ready()), $Player.velocity]

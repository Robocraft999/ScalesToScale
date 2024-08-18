extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProgressStore.jump_enabled = true
	ProgressStore.double_jump_enabled = true
	ProgressStore.dash_enabled = true
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if $Player.is_dash_active():
		var new_value = 100 * abs(1 - ($Player.DASH_DURATION_MILLIS - $Player.dash_active_time_remaining()) / float($Player.DASH_DURATION_MILLIS))
		%DashBar.value = int(new_value) if new_value > 10 else 0
	elif $Player.dash_timeout_remaining() == 0:
		%DashBar.value = 100
	else:
		var time_passed = ($Player.DASH_REFRESH_MILLIS - $Player.dash_timeout_remaining())
		var percentage = time_passed / float($Player.DASH_REFRESH_MILLIS)
		%DashBar.value  = percentage * 100.0

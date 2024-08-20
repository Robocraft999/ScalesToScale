extends TextureProgressBar

@onready var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_parent().get_parent().find_children("Player")[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	visible = ProgressStore.dash_enabled
	if ProgressStore.dash_enabled:
		if player.is_dash_active():
			var new_value = 100 * abs(1 - (player.DASH_DURATION_MILLIS - player.dash_active_time_remaining()) / float(player.DASH_DURATION_MILLIS))
			self.value = int(new_value) if new_value > 10 else 0
		elif player.dash_timeout_remaining() == 0:
			self.value = 100
		else:
			var time_passed = (player.DASH_REFRESH_MILLIS - player.dash_timeout_remaining())
			var percentage = time_passed / float(player.DASH_REFRESH_MILLIS)
			self.value  = percentage * 100.0

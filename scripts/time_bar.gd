extends TextureProgressBar

@onready var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_parent().get_parent().find_children("Player")[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if ProgressStore.time_scale_enabled:
		if not Global.timer.is_stopped():
			visible = true
			#TODO add max time and rename timer
			self.value = 100 * Global.timer.time_left / 10
		else:
			visible = false
			self.value = 100

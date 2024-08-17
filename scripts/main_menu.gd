extends Node


func _ready() -> void:
	%StartButton.grab_focus()
	%QuitButton.pressed.connect(_on_quit_button_pressed)
	%StartButton.pressed.connect(_on_start_button_pressed)
	%LevelButton.pressed.connect(_on_level_button_pressed)

func _on_quit_button_pressed():
	get_tree().quit()

func _on_start_button_pressed():
	pass # TODO: Start game

func _on_level_button_pressed():
	pass # TODO: Level selection

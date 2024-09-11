extends PausePanel

@export var difficulty_slider:HSlider
@export var quit_button:Button

func _ready_scene() -> void:
	difficulty_slider.connect("drag_ended", check_value)
	quit_button.connect("pressed", quit_game)

func _load_settings() -> void:
	_game_settings = ConfigFileHandler.load_game_settings()
	print('hey')
	difficulty_slider.value = _game_settings.difficulty

func quit_game() -> void:
	get_tree().quit()

func check_value(value_changed:bool) -> void:
	if value_changed:
		print('guardando')
		save_setting("game", "difficulty", difficulty_slider.value)

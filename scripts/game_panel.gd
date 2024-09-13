extends PausePanel

@export var difficulty_slider:HSlider
@export var quit_button:Button
@export var language_option:OptionButton

func _ready_scene() -> void:
	difficulty_slider.connect("drag_ended", save_difficulty)
	quit_button.connect("pressed", quit_game)
	language_option.connect("item_selected", save_language)

func _apply_settings() -> void:
	difficulty_slider.value = game_settings.difficulty
	language_option.selected = game_settings.language

func quit_game() -> void:
	get_tree().quit()

func save_difficulty(value_changed:bool) -> void:
	if value_changed:
		save_setting("game", "difficulty", difficulty_slider.value)

func save_language(index:int) -> void:
	save_setting("game", "language", index)

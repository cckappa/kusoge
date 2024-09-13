extends PausePanel

@export var fullscreen_checkbox:CheckBox
@export var resolution_option:OptionButton

func _ready_scene() -> void:
	fullscreen_checkbox.connect("toggled", save_fullscreen)
	resolution_option.connect("item_selected", save_resolution)

func _apply_settings() -> void:
	fullscreen_checkbox.button_pressed = video_settings.fullscreen
	resolution_option.selected = video_settings.screen_resolution

func save_fullscreen(toggle_on:bool) -> void:
	save_setting("video", "fullscreen", toggle_on)

func save_resolution(index:int) -> void:
	save_setting("video", "screen_resolution", index)

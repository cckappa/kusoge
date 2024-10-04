extends PausePanel

@export var fullscreen_checkbox:CheckBox
@export var resolution_option:OptionButton

func _ready_scene() -> void:
	load_screen_resolutions()
	fullscreen_checkbox.connect("toggled", save_fullscreen)
	resolution_option.connect("item_selected", save_resolution)

func _apply_settings() -> void:
	fullscreen_checkbox.button_pressed = video_settings.fullscreen
	resolution_option.selected = video_settings.screen_resolution

func load_screen_resolutions() -> void:
	for resolution:Vector2 in ConfigFileHandler.screen_resolutions:
		resolution_option.add_item("%dx%d" % [resolution[0], resolution[1]])

func save_fullscreen(toggle_on:bool) -> void:
	if toggle_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	save_setting("video", "fullscreen", toggle_on)

func save_resolution(index:int) -> void:
	var resolution_arr := resolution_option.get_item_text(index).split("x")
	var resolution_v2 := Vector2(resolution_arr[0].to_int(), resolution_arr[1].to_int())
	#DisplayServer.window_set_size(resolution_v2)
	get_window().size = resolution_v2
	save_setting("video", "screen_resolution", index)

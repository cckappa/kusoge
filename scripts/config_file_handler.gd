extends Node

var config := ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"
var game_settings:Dictionary
var accesibility_settings:Dictionary
var audio_settings:Dictionary
var video_settings:Dictionary

const screen_resolutions:= [
	Vector2(3840, 2160),
	Vector2(1920,1080),
	Vector2(1440, 1080),
	Vector2(1280, 1080),
	Vector2(1280, 720),
	Vector2(720, 480),
	Vector2(640, 480)
]

@onready var MASTER_BUS_ID:=AudioServer.get_bus_index("Master")
@onready var MUSIC_BUS_ID:=AudioServer.get_bus_index("Music")
@onready var SFX_BUS_ID:=AudioServer.get_bus_index("SFX")

func _ready() -> void:
	if not FileAccess.file_exists(SETTINGS_FILE_PATH):
		# GamePanel Settings 
		config.set_value("game", "difficulty", 1)
		config.set_value("game", "language", 0)
		
		# AccesibilityPanel Settings
		config.set_value("accesibility", "animated_text", 1)
		config.set_value("accesibility", "scale_text", 8)
		config.set_value("accesibility", "speed_text", 20)
		
		# AudioPanel Settings
		config.set_value("audio", "master_volume", 80)
		config.set_value("audio", "music_volume", 100)
		config.set_value("audio", "sfx_volume", 100)
		
		# VideoPanel Settings
		config.set_value("video", "fullscreen", 1)
		config.set_value("video", "screen_resolution", 0)
		
		# Save and Load to settings
		config.save(SETTINGS_FILE_PATH)
		load_settings()
		apply_settings()
	else:
		config.load(SETTINGS_FILE_PATH)
		load_settings()
		apply_settings()

func save_settings_to_file() -> void:
	config.save(SETTINGS_FILE_PATH)

func save_setting(section:String, key:String, value:Variant) -> void:
	config.set_value(section, key, value)

func load_settings() -> void:
	for key in config.get_section_keys("game"):
		game_settings[key] = config.get_value("game", key)
	for key in config.get_section_keys("accesibility"):
		accesibility_settings[key] = config.get_value("accesibility", key)
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)
	for key in config.get_section_keys("video"):
		video_settings[key] = config.get_value("video", key)

func apply_settings() -> void:
	# GamePanel Settings
	
	# AccesibilityPanel Settings
	
	# AudioPanel Settings
	AudioServer.set_bus_volume_db(MASTER_BUS_ID, Functions.get_decimal(config.get_value("audio", "master_volume")))
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, Functions.get_decimal(config.get_value("audio", "music_volume")))
	AudioServer.set_bus_volume_db(SFX_BUS_ID, Functions.get_decimal(config.get_value("audio", "sfx_volume")))
	
	# VideoPanel Settings
	# if config.get_value("video", "fullscreen"):
	# 	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	# else:
	# 	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	# get_window().size = screen_resolutions[config.get_value("video", "screen_resolution")]

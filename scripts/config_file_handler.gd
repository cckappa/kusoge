extends Node

var config := ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"

func _ready() -> void:
	if not FileAccess.file_exists(SETTINGS_FILE_PATH):
		# GamePanel settings 
		config.set_value("game", "difficulty", 1)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)

func save_game_setting(key:String, value:Variant) -> void:
	config.set_value("game", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_game_settings() -> Dictionary:
	var settings := {}
	for key in config.get_section_keys("game"):
		settings[key] = config.get_value("game", key)
	
	return settings

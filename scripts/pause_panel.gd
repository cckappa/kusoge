class_name PausePanel
extends PanelContainer

var _game_settings:Dictionary

func _ready() -> void:
	_ready_scene()
	_load_settings()

func _ready_scene() -> void:
	pass

func save_setting(section:String, key:String, value:Variant) -> void:
	match(section):
		"game":
			ConfigFileHandler.save_game_setting(key, value)

func _load_settings() -> void:
	pass

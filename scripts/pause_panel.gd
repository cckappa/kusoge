class_name PausePanel
extends PanelContainer

@onready var game_settings:=ConfigFileHandler.game_settings
@onready var accesibility_settings:=ConfigFileHandler.accesibility_settings
@onready var audio_settings:=ConfigFileHandler.audio_settings
@onready var video_settings:=ConfigFileHandler.video_settings

func _ready() -> void:
	SignalBus.connect("settings_discarded", _apply_settings)
	_ready_scene()
	_apply_settings()

func _ready_scene() -> void:
	pass

func save_setting(section:String, key:String, value:Variant) -> void:
	ConfigFileHandler.save_setting(section, key, value)

func _apply_settings() -> void:
	pass

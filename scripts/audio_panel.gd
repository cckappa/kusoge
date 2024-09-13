extends PausePanel

@export_category('Master')
@export var master_slider:HSlider
@export var master_label:Label

@export_category('Music')
@export var music_slider:HSlider
@export var music_label:Label

@export_category('SFX')
@export var sfx_slider:HSlider
@export var sfx_label:Label

var sliders:Array[HSlider]
var labels:Array[Label]

@onready var MASTER_BUS_ID:=AudioServer.get_bus_index("Master")
@onready var MUSIC_BUS_ID:=AudioServer.get_bus_index("Music")
@onready var SFX_BUS_ID:=AudioServer.get_bus_index("SFX")

func _ready_scene() -> void:
	master_slider.connect("value_changed", save_master)
	music_slider.connect("value_changed", save_music)
	sfx_slider.connect("value_changed", save_sfx)

func _apply_settings() -> void:
	master_slider.value = audio_settings.master_volume
	master_label.text = "%d" % audio_settings.master_volume
	AudioServer.set_bus_volume_db(MASTER_BUS_ID, Functions.get_decimal(audio_settings.master_volume))
	
	music_slider.value = audio_settings.music_volume
	music_label.text = "%d" % audio_settings.music_volume
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, Functions.get_decimal(audio_settings.master_volume))
	
	sfx_slider.value = audio_settings.sfx_volume
	sfx_label.text = "%d" % audio_settings.sfx_volume
	AudioServer.set_bus_volume_db(SFX_BUS_ID, Functions.get_decimal(audio_settings.master_volume))

func save_master(slider_val:float) -> void:
	master_label.text = "%d" % slider_val
	AudioServer.set_bus_volume_db(MASTER_BUS_ID, Functions.get_decimal(slider_val))
	save_setting("audio", "master_volume", slider_val)

func save_music(slider_val:float) -> void:
	music_label.text = "%d" % slider_val
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, Functions.get_decimal(slider_val))
	save_setting("audio", "music_volume", slider_val)

func save_sfx(slider_val:float) -> void:
	sfx_label.text = "%d" % slider_val
	AudioServer.set_bus_volume_db(SFX_BUS_ID, Functions.get_decimal(slider_val))
	save_setting("audio", "sfx_volume", slider_val)

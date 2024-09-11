extends PanelContainer

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

func _ready() -> void:
	master_slider.connect("value_changed", master_change)
	music_slider.connect("value_changed", music_change)
	sfx_slider.connect("value_changed", sfx_change)


func master_change(slider_val:float) -> void:
	master_label.text = "%d" % slider_val

func music_change(slider_val:float) -> void:
	music_label.text = "%d" % slider_val

func sfx_change(slider_val:float) -> void:
	sfx_label.text = "%d" % slider_val

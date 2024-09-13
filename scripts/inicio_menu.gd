extends Control

const inicial := preload("res://scenes/inicial.tscn")
@export var play:Button
@export var settings:Button
@export var settings_menu:Control

func _ready()->void:
	play.connect("pressed", start_game)
	settings.connect("pressed", open_settings)

func start_game()->void:
	get_tree().change_scene_to_packed(inicial)

func open_settings() -> void:
	settings_menu.visible = true
	get_tree().paused = true

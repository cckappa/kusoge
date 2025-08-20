extends Control

const inicial := preload("res://scenes/inicial.tscn")
const demo_scene := preload("res://scenes/maps/demo_tecnico_hub.tscn")
@export var play:Button
@export var settings:Button
@export var settings_menu:Control

@onready var black_rect := %BlackRect

func _ready()->void:
	GameSaveHandler.load_game()
	Globals.reset_lives()
	play.connect("pressed", start_game)
	play.grab_focus()
	settings.connect("pressed", open_settings)
	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "OUT", 2)

func start_game()->void:
	await Functions.fade_color_rect(black_rect, "IN", 2)
	if ProjectSettings.get_setting("application/config/version") == "demo":
		get_tree().change_scene_to_packed(demo_scene)
	else:
		get_tree().change_scene_to_packed(inicial)

func open_settings() -> void:
	settings_menu.visible = true
	get_tree().paused = true

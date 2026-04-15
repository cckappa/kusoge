extends Control

const inicial := preload("res://scenes/inicial.tscn")
const demo_scene := preload("res://scenes/maps/demo_tecnico_hub.tscn")
# @export var play:Button
# @export var settings:Button
# @export var settings_menu:Control

@onready var black_rect := %BlackRect
@onready var intro_screen := $IntroScreen

var started_game: bool = false

func _ready()->void:
	# print("Inicio menu ready")
	# intro_screen.connect("intro_screen_finished", _on_intro_screen_finished)
	# play.grab_focus()
	# play.connect("pressed", start_game)
	# settings.connect("pressed", open_settings)
	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "OUT", 2)
	# state_chart.send_event("to_start")

func start_game()->void:
	if !started_game:
		started_game = true
		GameSaveHandler.load_game()
		Globals.reset_lives()
		await Functions.fade_color_rect(black_rect, "IN", 2)
		if ProjectSettings.get_setting("application/config/version") == "demo":
			if Globals.current_map_path != null and Globals.current_map_path != "":
				var map_scene := load(Globals.current_map_path)
				if map_scene:
					get_tree().change_scene_to_packed(map_scene)
				else:
					print("Error loading saved map scene, loading demo hub instead.")
					get_tree().change_scene_to_packed(demo_scene)
			else:
				get_tree().change_scene_to_packed(demo_scene)
		else:
			get_tree().change_scene_to_packed(inicial)

# func open_settings() -> void:
# 	settings_menu.visible = true
# 	get_tree().paused = true


# func _on_borrar_partida_pressed() -> void:
# 	GameSaveHandler.clear_save_file()


# func _on_exit_pressed() -> void:
# 	get_tree().quit()

# func _on_intro_screen_finished() -> void:
# 	print("Intro screen finished signal received")
extends LimboState

@onready var play:=%Play
@onready var black_rect := %BlackRect

const INICIAL := preload("res://scenes/inicial.tscn")
const DEMO_SCENE := preload("res://scenes/maps/demo_tecnico_hub.tscn")

func _enter() -> void:
	play.grab_focus()

func _on_play_pressed() -> void:
	if is_active():
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
					get_tree().change_scene_to_packed(DEMO_SCENE)
			else:
				get_tree().change_scene_to_packed(DEMO_SCENE)
		else:
			get_tree().change_scene_to_packed(INICIAL)
	
func _on_focus_entered() -> void:
	if is_active():
		pass

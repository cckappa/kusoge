extends LimboState

@onready var play:=%Play
@onready var partida_nueva:=%PartidaNueva
@onready var partida_nueva_panel:=%PartidaNueva/PanelContainer

func _setup() -> void:
	if not GameSaveHandler.save_file_exists():
		partida_nueva_panel.visible = false
		partida_nueva.disabled = true
		partida_nueva.focus_mode = Control.FOCUS_NONE

func _enter() -> void:
	play.grab_focus()

func _on_play_pressed() -> void:
	if is_active():
		dispatch("to_started_game")
		start_game()
		

func _on_quit_pressed() -> void:
	if is_active():
		dispatch("to_quitted_game")
		await Functions.fade_color_rect(blackboard.get_var("black_rect"), "IN", 0.5)
		get_tree().quit()


func _on_partida_nueva_pressed() -> void:
	if is_active():
		dispatch("to_menu_juego_nuevo")

func start_game() -> void:
	GameSaveHandler.load_game()
	Globals.reset_lives()
	await Functions.fade_color_rect(blackboard.get_var("black_rect"), "IN", 2)
	# if ProjectSettings.get_setting("application/config/version") == "demo":
	# 	if Globals.current_map_path != null and Globals.current_map_path != "":
	# 		var map_scene := load(Globals.current_map_path)
	# 		if map_scene:
	# 			get_tree().change_scene_to_packed(map_scene)
	# 		else:
	# 			print("Error loading saved map scene, loading demo hub instead.")
	# 			get_tree().change_scene_to_packed(blackboard.get_var("demo_scene"))
	# 	else:
	# 		get_tree().change_scene_to_packed(blackboard.get_var("demo_scene"))
	# else:
	get_tree().change_scene_to_packed(blackboard.get_var("inicial_scene"))
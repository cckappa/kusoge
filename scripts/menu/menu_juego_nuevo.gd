extends LimboState

@onready var panel_container:PanelContainer=$Control/PanelContainer
@onready var volver:=%Volver
@onready var iniciar_partida_nueva:=%IniciarPartidaNueva
@onready var control_node:=$Control

var tween_time: float = 0.2
var y_offset: float = 150

func _setup() -> void:
	panel_container.modulate = Color(1,1,1,0)
	control_node.visible = true

func _enter() -> void:
	var tween : Tween= create_tween()
	tween.tween_property(panel_container, "position", Vector2(panel_container.position.x, panel_container.position.y - y_offset), tween_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(panel_container, "modulate", Color.hex(0xffffffff), tween_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	volver.grab_focus()

func _on_volver_pressed() -> void:
	if is_active():
		dispatch("to_menu_base")
		var tween : Tween= create_tween()
		tween.tween_property(panel_container, "position", Vector2(panel_container.position.x, panel_container.position.y + y_offset), tween_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.parallel().tween_property(panel_container, "modulate", Color.hex(0xffffff00), tween_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _on_iniciar_partida_nueva_pressed() -> void:
	if is_active():
		dispatch("to_started_game")
		GameSaveHandler.clear_save_file()
		start_game()

func start_game() -> void:
	GameSaveHandler.load_game()
	Globals.reset_lives()
	await Functions.fade_color_rect(blackboard.get_var("black_rect"), "IN", 2)
	if ProjectSettings.get_setting("application/config/version") == "demo":
		if Globals.current_map_path != null and Globals.current_map_path != "":
			var map_scene := load(Globals.current_map_path)
			if map_scene:
				get_tree().change_scene_to_packed(map_scene)
			else:
				print("Error loading saved map scene, loading demo hub instead.")
				get_tree().change_scene_to_packed(blackboard.get_var("demo_scene"))
		else:
			get_tree().change_scene_to_packed(blackboard.get_var("demo_scene"))
	else:
		get_tree().change_scene_to_packed(blackboard.get_var("inicial_scene"))


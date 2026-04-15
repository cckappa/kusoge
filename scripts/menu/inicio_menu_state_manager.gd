extends Node

@onready var state_chart:=%StateChart
@onready var black_rect := %BlackRect
@onready var play := %Play

const inicial := preload("res://scenes/inicial.tscn")
const demo_scene := preload("res://scenes/maps/demo_tecnico_hub.tscn")

func _ready() -> void:	
	pass

# STATES
func _on_start_state_entered() -> void:
	play.grab_focus()
	play.connect("pressed", _on_play_pressed)

func _on_jugar_state_entered() -> void:
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
	

# SIGNALS
func _on_play_pressed() -> void:
	play.disconnect("pressed", _on_play_pressed)
	state_chart.send_event("to_jugar")

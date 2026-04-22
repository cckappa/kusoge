extends Control

const inicial := preload("res://scenes/maps/cueva_demo_tecnico.tscn")
const demo_scene := preload("res://scenes/maps/demo_tecnico_hub.tscn")

@onready var inicio_menu_limbo_hsm:LimboHSM=$InicioMenuLimboHSM
@onready var black_rect := %BlackRect
@onready var intro_screen := $IntroScreen

var started_game: bool = false

func _ready()->void:
	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "OUT", 2)
	inicio_menu_limbo_hsm.dispatch("to_menu_base")

# func start_game()->void:
# 	if !started_game:
# 		started_game = true
# 		GameSaveHandler.load_game()
# 		Globals.reset_lives()
# 		await Functions.fade_color_rect(black_rect, "IN", 2)
# 		get_tree().change_scene_to_packed(inicial)
# 		# if ProjectSettings.get_setting("application/config/version") == "demo":
# 		# 	if Globals.current_map_path != null and Globals.current_map_path != "":
# 		# 		var map_scene := load(Globals.current_map_path)
# 		# 		if map_scene:
# 		# 			get_tree().change_scene_to_packed(map_scene)
# 		# 		else:
# 		# 			print("Error loading saved map scene, loading demo hub instead.")
# 		# 			get_tree().change_scene_to_packed(demo_scene)
# 		# 	else:
# 		# 		get_tree().change_scene_to_packed(demo_scene)
# 		# else:
# 		# 	get_tree().change_scene_to_packed(inicial)
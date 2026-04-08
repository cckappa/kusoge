@tool
extends BaseScene

@onready var world_animation_player := $WorldAnimationPlayer

func _ready_scene() -> void:
	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "OUT", 2)

func key_variable_logic() -> void:
	if Globals.key_variables.has("key_name") and Globals.key_variables["key_name"] == "key_value":
		pass

func map_state_logic() -> void:
	match Globals.maps[single_map_resource.map_name].state:
		"default":
			world_animation_player.play("RESET")
		"ending":
			world_animation_player.play("set_ending")
		_:
			pass
	
func dialogic_logic(event_name: String) -> void:
	print("Dialogic text signal received:", event_name)
	if event_name == "event_name":
		set_status_name()
		# Globals.set_map_state(single_map_resource.map_name, "event_name")

func set_status_name() -> void:
	pass

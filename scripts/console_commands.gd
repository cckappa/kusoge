extends Node

func _ready() -> void:
	# Register the console command
	# Los valores de las variables se pasan como strings, luego se convierten al tipo correcto como dentro de la función console_set_dialogic_variable

	Console.add_command("dialogic", console_set_dialogic_variable, ["VARIABLE_PATH.VARIABLE_PATH.VARIABLE_NAME", "VALUE", "TYPE"], 2, "Cambia el valor de una variable de Dialogic. El formato de VARIABLE_PATH es: FOLDER_NAME.VARIABLE_NAME o FOLDER_NAME.SUBFOLDER_NAME.VARIABLE_NAME. El tipo puede ser INT, FLOAT, BOOL o STRING.")
	Console.add_command("roomstate", console_set_room_state, ["ROOM_NAME", "STATE_NAME"], 2, "Cambia el estado de una habitación para testing.")
	Console.add_command("goto", console_go_to_room, ["TARGET_SCENE", "TARGET_MARKER"], 1, "Cambia a la escena especificada. TARGET_MARKER es opcional y por defecto es 'DefaultMarker'.")
	Console.add_command("overwrite", console_set_overwrite_state, ["OVERWRITE_VALUE"], 1, "Cambia overwrite value en Globals para poder usar room_state en base_scene.")

func console_set_dialogic_variable(var_path: String, value: Variant, type: String) -> void:
	var var_paths := var_path.split(".")
	if var_paths.size() != 3:
		print("Invalid variable path. Use the format: VARIABLE_PATH.VARIABLE_PATH.VARIABLE_NAME")
		return

	if type == "":
		type = "STRING" # Default to STRING if no type is provided
	
	match type.to_upper():
		"INT":
			value = int(value)
		"FLOAT":
			value = float(value)
		"BOOL":
			value = value.to_lower() in ["true", "1", "yes"]
		"STRING":
			pass
		_:
			print("Invalid type specified. Use INT, FLOAT, BOOL, or STRING.")
			return

	print("Dialogic variable:", var_path, " has value:", Dialogic.VAR.get(var_paths[0]).get(var_paths[1]).get(var_paths[2]))
	Dialogic.VAR.get(var_paths[0]).get(var_paths[1]).set(var_paths[2], value)
	print("Set Dialogic variable:", var_path, " to value:", Dialogic.VAR.get(var_paths[0]).get(var_paths[1]).get(var_paths[2]), " of type:", type)

func console_set_room_state(room_name: String, state_name: String) -> void:
	if Globals.maps.has(room_name):
		Globals.maps[room_name].state = state_name
		print("Set room:", room_name, " to state:", state_name)
	else:
		print("Room not found:", room_name)

func console_go_to_room(target_scene: String, target_marker: String = "DefaultMarker") -> void:
	print("Going to scene:", target_scene, " with marker:", target_marker)
	SignalBus.emit_signal("changing_scene")
	Globals.from_door = true
	Globals.target_marker = target_marker
	get_tree().change_scene_to_file(target_scene)

func console_set_overwrite_state(overwrite_value: String) -> void:
	Globals.overwrite_map_state = overwrite_value.to_lower() in ["true", "1", "yes"]
	print("Set overwrite_map_state to: ", overwrite_value, " (current value in Globals: ", Globals.overwrite_map_state, ")")

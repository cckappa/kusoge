extends Node

@onready var bus_index := AudioServer.get_bus_index("Music")

var pitch_effect:AudioEffectPitchShift
var reverb_effect:AudioEffectReverb
var stored_dialogic_events: Array = []

func _ready()->void:
	pitch_effect = AudioServer.get_bus_effect(bus_index, 0) as AudioEffectPitchShift
	reverb_effect = AudioServer.get_bus_effect(bus_index, 1) as AudioEffectReverb

func get_decimal(val:float) -> float:
	val = val * 0.1
	val = linear_to_db(val)
	return val

func array_to_string(arr: Array[StringName], separator:= "") -> String:
	var s := ""
	var ind := 0
	for i in arr:
		ind += 1
		if ind != arr.size():
			s += String(i) + separator
		else:
			s += String(i)
	return s

func fade_color_rect(rect: ColorRect, type: StringName, duration: float) -> bool:
	if rect == null:
		print("ColorRect is null!")
		return false
	
	if not rect.is_inside_tree():
		print("ColorRect is not in tree!")
		return false
		
	match type:
		"IN":
			var tween := rect.create_tween()
			tween.tween_property(rect, "modulate", Color.hex(0x000000fe), duration).set_trans(Tween.TRANS_SINE)
			await tween.finished
			return true
		"OUT":
			var tween := rect.create_tween()
			tween.tween_property(rect, "modulate", Color.hex(0x00000000), duration).set_trans(Tween.TRANS_SINE)
			await tween.finished
			return true
		_:
			return true


func control_shake(object:Control, force_x:float, force_y:float, amount_x:float, amount_y:float, duration:float) -> void:
	if not object:
		return
	
	var tween := object.create_tween()
	var original_position := object.position
	
	for i in range(int(duration * 30)):  # 30 shakes per second
		var offset_x := randf_range(-force_x, force_x) * amount_x
		var offset_y := randf_range(-force_y, force_y) * amount_y
		tween.tween_property(object, "position", original_position + Vector2(offset_x, offset_y), 0.03)  # Fast movement

	tween.tween_property(object, "position", original_position, 0.1)  # Reset to original position


func set_game_speed(speed:float) -> void:
	Engine.time_scale = speed
	if speed == 1.0:
		pitch_effect.pitch_scale = speed
		AudioServer.set_bus_effect_enabled(bus_index, 1, false)
	else:
		pitch_effect.pitch_scale = 0.98
		AudioServer.set_bus_effect_enabled(bus_index, 1, true)


func ran_from_current_scene() -> bool:
	var root := get_tree().root
	var child_count := root.get_child_count()
	
	# When running with F6: root has autoloads + 1 scene
	# When running with F5: root has autoloads + main scene (which may load other scenes)
	
	# Get the last child (the actual game scene, after autoloads)
	var main_scene := root.get_child(child_count - 1)
	
	# Check if this scene is the project's main scene
	var project_main_scene :String= ProjectSettings.get_setting("application/run/main_scene")
	
	# If the current scene's file path doesn't match the project main scene, it's F6
	if main_scene.scene_file_path != project_main_scene:
		return true
	
	return false
	# var STARTED_FROM_MAIN := false
	# var tree := get_tree()
	# var main_scene_path :String= ProjectSettings.get_setting("application/run/main_scene")
	
	# # # Get the file path of the current active scene
	# var current_scene_path :String= tree.current_scene.scene_file_path

	# if main_scene_path == current_scene_path:
	# 	# # Code here runs when launched with "Run Project" (F5)
	# 	STARTED_FROM_MAIN = true
	# 	print("Launched with Run Project (F5)")
	# else:
	# 	# Code here runs when launched with "Run Current Scene" (F6)
	# 	print("Launched with Run Current Scene (F6)")
	# print("Current Scene Path: ", get_tree().current_scene)
	# print("Self: ", self)
	# if get_tree().current_scene == self:
	# 	return true
	# else:
	# 	return false

# func set_dialogic_auto_advance(enabled:bool) -> void:
# 	# Dialogic.Inputs.auto_advance.enabled_until_user_input = not enabled
# 	# Dialogic.Inputs.auto_advance.enabled_until_next_event = enabled
# 	# Dialogic.Inputs.auto_advance = not enabled
# 	Dialogic.Inputs.auto_advance.enabled_forced = enabled
# 	Dialogic.Inputs.manual_advance.system_enabled = not enabled
# 	Dialogic.Inputs.auto_skip.disable_on_user_input = not enabled
# 	# Dialogic.Inputs.auto_skip.enabled = enabled
# 	# Dialogic.Inputs.auto_skip.time_per_event = 3.0 if enabled else 0.1
# 	# Dialogic.Inputs.manual_advance.disabled_until_next_event = enabled
# 	# Dialogic.Inputs.auto_skip.

# func set_dialogic_auto_advance(enabled: bool) -> void:
# 	if enabled:
# 		Dialogic.Inputs.auto_advance.enabled_forced = true
# 		Dialogic.Inputs.auto_advance.enabled_until_user_input = false  # Don't disable on input
# 		Dialogic.Inputs.manual_advance.system_enabled = true
# 	else:
# 		Dialogic.Inputs.auto_advance.enabled_forced = false
# 		Dialogic.Inputs.auto_advance.enabled_until_user_input = true
# 		Dialogic.Inputs.manual_advance.system_enabled = false

func set_dialogic_auto_advance(enabled: bool) -> void:
	# var events := InputMap.action_get_events("dialogic_default_action")
	if enabled:
		# Enable auto-advance
		Dialogic.Inputs.auto_advance.enabled_forced = true
		Dialogic.Inputs.auto_advance.enabled_until_user_input = false
		
		# Disable the dialogic_default_action input
		# InputMap.action_set_deadzone("dialogic_default_action", 1.0)
		# Or completely erase it temporarily
		# Store and erase the input events
		stored_dialogic_events = InputMap.action_get_events("dialogic_default_action")
		InputMap.action_erase_events("dialogic_default_action")
		# InputMap.action_erase_events("dialogic_default_action")
	else:
		# Disable auto-advance
		Dialogic.Inputs.auto_advance.enabled_forced = false
		Dialogic.Inputs.auto_advance.enabled_until_user_input = true
		
		# Restore the input events
		for event:InputEvent in stored_dialogic_events:
			InputMap.action_add_event("dialogic_default_action", event)
		stored_dialogic_events.clear()
		# Re-enable the input
		# InputMap.action_set_deadzone("dialogic_default_action", 0.5)
		# for event in events:
		# 	InputMap.action_add_event("dialogic_default_action", event)
		

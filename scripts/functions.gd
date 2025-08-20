extends Node

@onready var bus_index := AudioServer.get_bus_index("Music")

var pitch_effect:AudioEffectPitchShift
var reverb_effect:AudioEffectReverb

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

func fade_color_rect(rect:ColorRect, type:StringName, duration:float) -> bool:
	match type:
		"IN":
			var tween := get_tree().create_tween()
			tween.tween_property(rect, "modulate", Color.hex(0x000000fe), duration).set_trans(Tween.TRANS_SINE)
			await tween.finished
			return true
		"OUT":
			var tween := get_tree().create_tween()
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

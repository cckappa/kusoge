extends Node

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
			tween.tween_property(rect, "modulate", Color.hex(0x000000ff), duration).set_trans(Tween.TRANS_SINE)
			await tween.finished
			return true
		"OUT":
			var tween := get_tree().create_tween()
			tween.tween_property(rect, "modulate", Color.hex(0x00000000), duration).set_trans(Tween.TRANS_SINE)
			await tween.finished
			return true
		_:
			return true

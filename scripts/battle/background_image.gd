extends TextureRect

func _ready() -> void:
	SignalBus.connect("party_attacked", shift_squiggle)
	SignalBus.connect("enemy_attacked", shift_squiggle)

func shift_squiggle(normalized_center: Vector2) -> void:
	var _tween := create_tween()
	
	var strength_targets := [10.0, -9.0, 8.0, -11.0, 7.0, -8.0, 4.0, -3.0, 1.0]
	var scale_targets := [
		Vector2(12.0, 14.0), Vector2(4.0, 6.0), Vector2(11.0, 13.0),
		Vector2(5.0, 7.0), Vector2(10.0, 12.0), Vector2(6.0, 8.0),
		Vector2(8.0, 10.0), Vector2(7.0, 9.0), Vector2(7.0, 9.0)
	]
	
	for i in strength_targets.size():
		var s: float = material.get_shader_parameter("strength")
		var sc: Vector2 = material.get_shader_parameter("scale")
		_tween.tween_method(set_squiggle_strength, s, strength_targets[i], 0.05)
		_tween.parallel().tween_method(set_squiggle_scale, sc, scale_targets[i], 0.05)
	
	await _tween.finished
	material.set_shader_parameter("strength", 1.0)
	material.set_shader_parameter("scale", Vector2(7.0, 9.0))  # default

func set_squiggle_strength(value: float) -> void:
	material.set_shader_parameter("strength", value)

func set_squiggle_scale(value: Vector2) -> void:
	material.set_shader_parameter("scale", value)
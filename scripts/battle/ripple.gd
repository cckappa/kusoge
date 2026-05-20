extends ColorRect

var _active_tween: Tween

func _ready() -> void:
	visible = false
	
	SignalBus.connect("party_attacked", _on_attacked)
	SignalBus.connect("enemy_attacked", _on_attacked)

func _on_attacked(normalized_center:Vector2) -> void:
	material.set_shader_parameter("center", normalized_center)
	visible = true
	
	if _active_tween and _active_tween.is_valid():
		_active_tween.kill()

	_active_tween = create_tween()

	_active_tween.tween_method(set_distortion_radius, 0.0, 1.0, 0.6)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_active_tween.parallel().tween_method(set_distortion_strength, 0.05, 0.08, 0.15)
	_active_tween.parallel().tween_method(set_distortion_strength, 0.08, 0.05, 0.2)
	_active_tween.parallel().tween_method(set_distortion_feather, 0.145, 0.0, 0.4)
	_active_tween.parallel().tween_method(set_distortion_width, 0.07, 0.0, 0.05)
	
	await _active_tween.finished
	visible = false

func set_distortion_radius(value: float) -> void:
	material.set_shader_parameter("radius", value)

func set_distortion_strength(value: float) -> void:
	material.set_shader_parameter("strength", value)

func set_distortion_feather(value: float) -> void:
	material.set_shader_parameter("feather", value)

func set_distortion_width(value: float) -> void:
	material.set_shader_parameter("width", value)
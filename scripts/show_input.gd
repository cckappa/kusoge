class_name ShowInput
extends Sprite2D

var duration: float = 0.3

func _ready() -> void:
	visible = false
	modulate.a = 0.0

func appear_input_label() -> void:
	visible = true
	var tween : Tween= create_tween()
	tween.tween_property(self, "modulate", Color.hex(0xffffffff), duration).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(self, "offset", Vector2(0, -20), duration).set_trans(Tween.TRANS_SINE)

func disappear_input_label() -> void:
	var tween : Tween= create_tween()
	tween.tween_property(self, "modulate", Color.hex(0xffffff00), duration).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(self, "offset", Vector2(0, 0), duration).set_trans(Tween.TRANS_SINE)
	

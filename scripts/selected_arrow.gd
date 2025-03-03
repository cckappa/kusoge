extends TextureButton

func _ready() -> void:
	var tween := create_tween().set_loops()
	var posy := position.y
	tween.tween_property(self, "position", Vector2(0, posy-6), 0.4)
	tween.tween_property(self, "position", Vector2(0, posy), 0.4).from_current()

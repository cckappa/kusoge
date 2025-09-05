extends TextureButton

func _ready() -> void:
	var tween := create_tween().set_loops()
	var posy := position.y
	var posx := position.x
	tween.tween_property(self, "position", Vector2(posx, posy-9), 0.4)
	tween.tween_property(self, "position", Vector2(posx, posy), 0.4).from_current()

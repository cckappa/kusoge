extends TextureButton

@export var amount_hovering:int = 10

func _ready() -> void:
	var tween := create_tween().set_loops()
	var posy := position.y
	var posx := position.x
	tween.tween_property(self, "position", Vector2(posx, posy - amount_hovering), 0.4)
	tween.tween_property(self, "position", Vector2(posx, posy), 0.4).from_current()

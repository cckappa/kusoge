extends PanelContainer

func move_party() -> void:
	var tween := create_tween()
	tween.tween_property(self, "position", Vector2(2456, 429), 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN) 

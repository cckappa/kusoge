extends PanelContainer

var tween_time:=0.5

func move_init() -> void:
	var tween := create_tween()
	tween.tween_property(self, "position", Vector2(1484,687), tween_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT) 

func move_base() -> void:
	var tween := create_tween()
	tween.tween_property(self, "position", Vector2(469,202), tween_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT) 

func move_party() -> void:
	var tween := create_tween()
	tween.tween_property(self, "position", Vector2(1275, 60), tween_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT) 

func move_items() -> void:
	var tween := create_tween()
	tween.tween_property(self, "position", Vector2(1898, 98), tween_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT) 


